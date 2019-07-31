/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE RECREATE LOANS TRANSACTION INDX')            */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*       LEC0903 - RECREATE LOANS TRANSACTIONS INDEX FILE           */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR322731           Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      260524             Date 29May09              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CLE106              Date  01Aug04           */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01194              DATE  07FEB90           */
/*                      S01179              DATE  14/09/88          */
/*                                                                  */
/********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*       AR322731 - LEC0212A and APISERVER locks LTRIX               */
/*                  file (Child:AR322732)                            */
/*       260524 - Error 'Loan Number already exist.' on Loan         */
/*                Interest adjustment input. Clear LEADINQD.         */
/*       CLE106 - Syndication Manager                               */
/*       S01194 - NEW STANDING DATA                                 */
/*       S01179 - AS400 INCORPORATION                               */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&FLSIZ) TYPE(*DEC) LEN(5)
             DCL        VAR(&LESTAT) TYPE(*CHAR) LEN(256)
/**/
/*           DCLDTAARA  DTAARA(LESTAT)                              *  *S01179*/
/**/
             RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)
/**/
             CLRPFM     FILE(LTRIX)
             CHGVAR     VAR(&FLSIZ) VALUE(%SUBSTRING(&LESTAT 1 5))
/**********  INZPFM     FILE(LTRIX) TOTRCDS(&FLSIZ) */                                  /*AR322731*/
/**/
/**/
             SNDPGMMSG  MSG('CREATE LOANS TRANSACTION INDEX FILE') +
                        TOMSGQ(MRUNQ)
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEEE)         */        /*S01194*/
/**********  CALL       PGM(LE0832) */                                                  /*AR322731*/
/**/
             CLRPFM     FILE(LEADINPD)                                /*CLE106*/
             CLRPFM     FILE(LEADINQD)                                                    /*260524*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
