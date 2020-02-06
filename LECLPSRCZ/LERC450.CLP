/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Produce prof file : GL & RE')                */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                     */
/*                                                                   */
/*       LERC450 - Produce report/enq file - RETAIL & GENERAL LEDGER */
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
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
     SNDPGMMSG  MSG('Produce Profitability Report/Enquiry file : RT & GL') +
                                       TOMSGQ(MRUNQ)
 
/* CLEAR OUTPUT FILES */
 
     CLRPFM LENQRED
 
  /* Call Program */
 
             CALL       LER450
 
  /* IF ERROR, SEND MSG  */
 
     IF COND(%SWITCH(XXXXXX11)) THEN(DO)
 
            SNDPGMMSG  MSG('Job terminated, database in error. +
                           Contact Systems Department.') +
                           TOMSGQ(MOPERQ MRUNQ)
 
     ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
ENDPGM
