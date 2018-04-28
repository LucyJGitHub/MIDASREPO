/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE LOAN ACTIVITY ENQUIRY')                      */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*                  LEC0306-LOAN ACTIVITY ENQUIRY                   */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. 128954             Date 17Feb98              */
/*       Prev Amend No. S01408             Date 26Apr96              */
/*                      S01194             Date 08Feb90              */
/*                                                                  */
/********************************************************************/
/*       128954 - Call new program LE0212 instead of LE0210 if      */
/*                CLE004 is installed                               */
/*       S01408 - Addition of core hooks: LEC0306001                */
/*                                        LEC0306002                */
/*       S01194 - NEW STANDING DATA                                 */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)        /*128954*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                   /*128954*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) +
                          VALUE('CLE004')                    /*128954*/
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEIC)                  * *S01194*/
                                                                     /*S01408*/
/**/                                                         /*128954*/
/* Determine if CLE004 installed  */                         /*128954*/
/**/                                                         /*128954*/
             CALL   PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)    /*128954*/
/**/                                                         /*128954*/
/* Error */                                                  /*128954*/
/**/                                                         /*128954*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                /*128954*/
             SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                                TOMSGQ(MOPERQ)               /*128954*/
             CHGJOB (XXXXXX11)                               /*128954*/
             GOTO       CMDLBL(EXIT)                         /*128954*/
             ENDDO                                           /*128954*/
/*/COPY WNCPYSRC,LEC0306001                                          */
                                                                     /*S01408*/
             IF         COND(&RTCD *EQ '       ') THEN(CALL +
                          PGM(LE0212))                       /*128954*/
             ELSE       CMD(DO)                              /*128954*/
             CALL       PGM(LE0210)
             ENDDO                                           /*128954*/
                                                                     /*S01408*/
/*/COPY WNCPYSRC,LEC0306002                                          */
                                                                     /*S01408*/
/*********** DLTOVR     FILE(*ALL)                                   * *S01194*/
EXIT:                                                        /*128954*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
