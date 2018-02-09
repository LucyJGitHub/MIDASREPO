/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Prof Report by Business Group - COB')        */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                     */
/*                                                                   */
/*       LERC47  - Profitability report by business group (COB)      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO. BH3518             DATE 28SEP92              */
/*                                         DATE ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BH3518  -  Make report run monthly, and on request          */
/*                                                                   */
/*********************************************************************/
 
 
/*PGM                                                                 /*BH3518*/
 
             PGM        PARM(&RSEQ &LVL &RENT)                        /*BH3518*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*BH3518*/
             DCL        VAR(&LVL) TYPE(*CHAR) LEN(1)                  /*BH3518*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*BH3518*/
     DCL VAR(&RTYP) TYPE(*CHAR) LEN(1) VALUE('T')
     DCL VAR(&PDAT) TYPE(*CHAR) LEN(7)
     DCL VAR(&USAC) TYPE(*CHAR) LEN(2)
     DCL VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Read LERSTS Data Area to get Processing Date for Report  */
 
     RTVDTAARA (LERSTS (122 7)) &PDAT
 
     SNDPGMMSG  MSG('Profitability Report by Business Group') +
                          TOMSGQ(MRUNQ)
 
/* Call Profitability Report Program with Full Report parameter  */
 
             CALL       PGM(LER470) PARM(&PDAT &RTYP &USAC &WSID)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
ENDPGM
