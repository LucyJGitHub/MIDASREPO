/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Manual repayments input')                    */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*                 LEC0210-MANUAL REPAYMENTS INPUT                  */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CLE034             Date 05May03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CLE105             Date 22Mar00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CLE004             Date 02Dec96              */
/*                      S01194             Date  08Feb90             */
/*                                                                  */
/********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*       CLE034 - Lending Enhancements.                              */
/*       CLE105 - LE Maintenance Function Switchability             */
/*       CLE004 - Customer Lending Enhancements - Syndications.      */
/*       S01194 - NEW STANDING DATA                                 */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)        /*CLE004*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                   /*CLE004*/
/*********** DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) + */
/***********              VALUE('CLE004')  */     /*CLE004*/ /*CLE105*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) +
                          VALUE('CLE105')                    /*CLE105*/
             DCL        VAR(&TSTMP) TYPE(*CHAR) LEN(26)                                   /*CLE034*/
/*/COPY WNCPYSRC,LEC0210002                                          */
/**/                                                         /*CLE004*/
/**Determine*If*CLE004*installed***/              /*CLE004*/ /*CLE105*/
/**/                                                         /*CLE004*/
/**Determine if CLE105 installed  */                         /*CLE105*/
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
             OVRDBF     FILE(LOAMD) TOFILE(LOAMS) SHARE(*NO)
/************OVRDBF     FILE(TABLE) TOFILE(TABLEIC)                  * *S01194*/
/*/COPY WNCPYSRC,LEC0210001                                          */
/**/                                                         /*CLE004*/
/**CLE004*installed**/                           /*CLE004*/  /*CLE105*/
/**/                                                         /*CLE004*/
/* CLE105 installed */                                       /*CLE105*/
             IF         COND(&RTCD *EQ '       ') THEN(+
               CALL     PGM(LE2110) PARM('I' 'LAMR' ' ' &TSTMP))                          /*CLE034*/
/**********    CALL     PGM(LE2110) PARM('I' 'LAMR' ' ')) */                      /*CLE004  CLE034*/
             ELSE       CMD(DO)                              /*CLE004*/
/**/                                                         /*CLE004*/
/***CLE004*not*installed**/                       /*CLE004*/ /*CLE105*/
/**/                                                         /*CLE004*/
/** CLE105 not installed */                                  /*CLE105*/
             CALL       PGM(LE0110)
             ENDDO                                           /*CLE004*/
             DLTOVR     FILE(*ALL)
EXIT:                                                        /*CLE004*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
