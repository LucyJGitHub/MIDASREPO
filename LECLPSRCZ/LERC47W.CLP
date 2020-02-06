/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Weekly Prof Reports - COB')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                     */
/*                                                                   */
/*       LERC47  - Profitability reports (COB weekly)                */
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
/*       Prev Amend No. MOF60              Date 23Mar92              */
/*                                         Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MOF60  - Customer Lending R10 enhancements                  */
/*                                                                   */
/*********************************************************************/
 
 
PGM
 
     DCL VAR(&RTYP) TYPE(*CHAR) LEN(1) VALUE('T')
     DCL VAR(&PDAT) TYPE(*CHAR) LEN(7)
     DCL VAR(&USAC) TYPE(*CHAR) LEN(2)
     DCL VAR(&WSID) TYPE(*CHAR) LEN(10)
     DCL VAR(&NEXT) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
     DCLF FILE(SDBANKPD)
 
/* Check if next working day is run date + 1. If not, this is a */
/* weekend and reports must be run automatically */
 
     RCVF  RCDFMT(SDBANKD0)
 
           CHGVAR &NEXT (&BJRDNB +1)
           IF (&NEXT *EQ &BJDNWD) THEN(GOTO END)
 
              CHGVAR &WSID 'WEEKLY    '
 /* MOF60 OVRD REQUIRED TO RELEASE SDBANKPD BEFORE CALL OF RPG PROGRAMS */
             OVRDBF     FILE(SDBANKPD) SHARE(*NO) /*MOF60*/
 
/* Read LERSTS Data Area to get Processing Date for Report  */
 
/* Call Profitability Report Programs with Full Report parameter  */
 
     RTVDTAARA (LERSTS (122 7)) &PDAT
 
     SNDPGMMSG  MSG('Profitability Report by Business Group') +
                          TOMSGQ(MRUNQ)
 
             CALL       PGM(LER470) PARM(&PDAT &RTYP &USAC &WSID)
 
     SNDPGMMSG  MSG('Profitability Report by Facility') +
                          TOMSGQ(MRUNQ)
 
             CALL       PGM(LER480) PARM(&PDAT &RTYP &USAC &WSID)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
