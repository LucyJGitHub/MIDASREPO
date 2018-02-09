/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Retrieve Server Data Area')                  */
/********************************************************************/
/*                                                                  */
/*  Midas   - Customer Lending Module                               */
/*                                                                  */
/*  LEC2010R - Lending PC INTERFACE CONTROL                         */
/*                                                                  */
/*  Function: To submit the Lending PC Interface process LEC2010A   */
/*            during input cycle initiation.                        */
/*                                                                  */
/*  Calls:    NONE                                                  */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. 200600             Date 11Jan02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CLE004  *CREATE    Date 21May97              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*  200600 - Reset data area to have flag set to 'N' if value read  */
/*           is 'Y' but still pass 'Y' back to LE2010M              */
/*  CLE004 - Customer Lending Enhancements - Syndications.          */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&DTAARA &FLAG)
 
             DCL        VAR(&FLAG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DTAARA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             RTVDTAARA  DTAARA(&DTAARA (1 1)) RTNVAR(&FLAG)
 
             IF         COND((&FLAG *EQ 'Y') *OR (&FLAG *EQ ' ')) +
                          THEN(CHGDTAARA DTAARA(&DTAARA) VALUE('N'))                      /*200600*/
                                                                                          /*200600*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
