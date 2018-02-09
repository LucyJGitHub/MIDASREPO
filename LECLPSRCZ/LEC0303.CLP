/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE OUTSTANDING LOANS BY FACILITIES')            */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*        LEC0303-OUTSTANDING LOANS BY FACILITY ENQUIRY             */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 136625             Date 16Jun98              */
/*                      CLE004             Date 02Dec96              */
/*                      S01311             Date 22Feb91              */
/*                      S01194                  Date  08Feb90       */
/*                                                                  */
/********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       136625 - Loans by Facility Enquiry and Loans by Participant */
/*                Facility looks identical.                          */
/*       CLE004 - Customer Lending Enhancements - Syndications.      */
/*       S01311 - EXPOSURE MANAGEMENT ENQUIRIES                     */
/*                LE0180 REWRITTEN AND REPLACED BY LE0181           */
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
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CLE004*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CLE004*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CLE004*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*CLE004*/
/**********  OVRDBF     FILE(TABLED) TOFILE(TABLEIC)                 * *S01194*/
/**/                                                                  /*CLE004*/
/* If SAR CLE004 is installed, files should not share access paths */ /*CLE004*/
/**/                                                                  /*CLE004*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CLE004*/
             CHGVAR     VAR(&SARD) VALUE('CLE004')                    /*CLE004*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)    /*CLE004*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CLE004*/
                OVRDBF     FILE(LOAMS) SHARE(*NO)                     /*CLE004*/
             ENDDO                                                    /*CLE004*/
                                                                     /*S01311*/
/************CALL       PGM(LE0180)                                   *S01311*/
/*********** CALL       PGM(LE0181)                            /*S01311 136625*/
             CALL       PGM(LE0181) PARM('OSLF')                      /*136625*/
                                                                     /*S01311*/
/*********** DLTOVR     FILE(*ALL)                                   * *S01194*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
