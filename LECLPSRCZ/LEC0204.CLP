/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Parts purchase')                             */
/*********************************************************************/
/*                                                                   */
/*        Midas     - Customer Lending Module                        */
/*                                                                   */
/*          LEC0204-PARTICIPATIONS PURCHASED INPUT                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CLE034             Date 05May03              */
/* Midas Release 4.01 -----------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CLE105             Date 22Mar00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CLE004             Date 02Dec96              */
/*                      S01465            Date  22Mar94              */
/*                      S01194            DATE  08FEB90              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CLE034 - Lending Enhancements.                              */
/*       CLE105 - LE Maintenance Function Switchability              */
/*       CLE004 - Customer Lending Enhancements - Syndications       */
/*       S01465 - BLI Lending Enhancement                            */
/*       S01194 - NEW STANDING DATA                                  */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                         /*CLE004*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)        /*CLE004*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                   /*CLE004*/
/*********** DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) + */
/***********              VALUE('CLE004')  */     /*CLE004*/ /*CLE105*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) +
                          VALUE('CLE105')                    /*CLE105*/
             DCL        VAR(&TSTMP) TYPE(*CHAR) LEN(26)                                   /*CLE034*/
/**/                                                         /*CLE004*/
/**Determine*if*CLE004*installed***/              /*CLE004*/ /*CLE105*/
/**/                                                         /*CLE004*/
/* Determine if CLE105 installed  */                         /*CLE105*/
             CALL   PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)    /*CLE004*/
/**/                                                         /*CLE004*/
/* Error */                                                  /*CLE004*/
/**/                                                         /*CLE004*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                /*CLE004*/
             SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                                TOMSGQ(MOPERQ)               /*CLE004*/
             CHGJOB (XXXXXX11)                               /*CLE004*/
             GOTO       CMDLBL(EXIT)                         /*CLE004*/
             ENDDO                                           /*CLE004*/
/**/                                                         /*CLE004*/
/**CLE004*installed**/                            /*CLE004*/ /*CLE105*/
/**/                                                         /*CLE004*/
/* CLE105 installed */                                       /*CLE105*/
/*/COPY WNCPYSRC,LEC0204002                                          */
             IF         COND(&RTCD *EQ '       ') THEN(+
                  CALL     PGM(LE2030) +
                           PARM('I' 'PTPU' ' ' ' ' &TSTMP))                               /*CLE034*/
/***********               PARM('I' 'PTPU' ' ' ' '))                           /*CLE004*/ /*CLE034*/
/*/COPY WNCPYSRC,LEC0204003                                          */
             ELSE       CMD(DO)                              /*CLE004*/
/**/                                                         /*CLE004*/
/***CLE004*not*installed**/                       /*CLE004*/ /*CLE105*/
/**/
/** CLE105 not installed */                                  /*CLE105*/
/**********  OVRDBF     FILE(TABLE) TOFILE(TABLEIC)                  * *S01194*/
/*/COPY WNCPYSRC,LEC0204001                                          */
             OVRDSPF    FILE(LE0050FM) SHARE(*YES)
             OVRDBF     FILE(PSOLD) SHARE(*NO)                        /*S01465*/
             CALL       PGM(LE0051)
             DLTOVR     FILE(*ALL)
             ENDDO                                           /*CLE004*/
EXIT:                                                        /*CLE004*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
