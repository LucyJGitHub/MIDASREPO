/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE LOAN DETAILS ENQUIRY')                       */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*                   LEC0304-LOAN DETAILS ENQUIRY                   */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CLE004             Date 02Dec96              */
/*                      S01194             Date 08Feb90             */
/*                                                                  */
/********************************************************************/
/*                                                                   */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CLE004 - Customer Lending Enhancements - Syndications.      */
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
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CLE004*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CLE004*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CLE004*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*CLE004*/
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEIC)                  * *S01194*/
/**/                                                                  /*CLE004*/
/* If SAR CLE004 is installed, files should not share access paths */ /*CLE004*/
/**/                                                                  /*CLE004*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CLE004*/
             CHGVAR     VAR(&SARD) VALUE('CLE004')                    /*CLE004*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)    /*CLE004*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CLE004*/
                OVRDBF     FILE(LOAMS) SHARE(*NO)                     /*CLE004*/
                OVRDBF     FILE(CLOAN) SHARE(*NO)                     /*CLE004*/
             ENDDO                                                    /*CLE004*/
             CALL       PGM(LE0190)
/*********** DLTOVR     FILE(*ALL)                                   * *S01194*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
