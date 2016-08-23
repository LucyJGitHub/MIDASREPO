/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Facilities input')                           */
/*********************************************************************/
/*                                                                   */
/*        Midas     - Customer Lending Module                        */
/*                                                                   */
/*                 LEC0201-FACILITIES INPUT                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CLE034             Date 05May03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Prev Amend No. CLE105         DATE  21MAR00                 */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      121855         DATE  14AUG97                 */
/*                      CLE004         DATE  28APR97                 */
/*                      S01408         DATE  06SEP96                 */
/*                      S01194         DATE  08FEB90                 */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CLE034 - Lending Enhancements.                              */
/*       CLE105 - LE Maintenance Function Switchability              */
/*       121855 - Share(*no) required because of call to window pgm  */
/*       CLE004 - Customer Lending Enhancements - Syndications       */
/*       S01408 - Add hook LEC0201MPS                                */
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
/*********** DCL        VAR(&MSGI) TYPE(*CHAR) LEN(1191)                       /*CLE004*/ /*CLE034*/
             DCL        VAR(&MSGI) TYPE(*CHAR) LEN(1272)                                  /*CLE034*/
             DCL        VAR(&MSGO) TYPE(*CHAR) LEN(177)      /*CLE004*/
/*********** DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) +
/***********              VALUE('CLE004')        /*CLE004*/  /*CLE105*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) +
                          VALUE('CLE105')                    /*CLE105*/
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
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEIC)                  * *S01194*/
             OVRDBF     FILE(FCLTY) SHARE(*NO)               /*121855*/
/**/                                                         /*CLE004*/
/**CLE004*installed**/                            /*CLE004*/ /*CLE105*/
/**/                                                         /*CLE004*/
/* CLE105 installed */                                       /*CLE105*/
             IF         COND(&RTCD *EQ '       ') THEN(CALL +
                          PGM(LE2020) PARM('I' &MSGI &MSGO)) /*CLE004*/
             ELSE       CMD(DO)                              /*CLE004*/
/**/                                                         /*CLE004*/
/***CLE004*not*installed**/                       /*CLE004*/ /*CLE105*/
/** CLE105 not installed */                                  /*CLE105*/
/*/COPY WNCPYSRC,LEC0201MPS                                             S01408*/
             CALL       PGM(LE0020)
             ENDDO                                           /*CLE004*/
/*/COPY WNCPYSRC,LEC0201001                                          */
/*********** DLTOVR     FILE(*ALL)                                   * *S01194*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*********** ENDPGM                                                  * *CLE004*/
EXIT:        ENDPGM                                          /*CLE004*/
