/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Produce prof file : loans')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                     */
/*                                                                   */
/*       LERC430 - Produce report/enq file - LOANS                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Last Amend No. 166037             Date 17Aug99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. MOF60              Date 23Mar92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       166037 - Margin for risk participants reported against agent*/
/*       MOF60  - Customer Lending R10 enhancements                  */
/*                                                                   */
/*********************************************************************/
 
PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
     SNDPGMMSG  MSG('Produce Profitability Report/Enquiry file : LOANS') +
                                       TOMSGQ(MRUNQ)
 
/* CLEAR OUTPUT FILES */
 
     CLRPFM LENQLND
     CLRPFM LEPRLNPD                                                  /*166037*/
             CALL       LER431                                        /*166037*/
 
  /* Call Program */
 
             CALL       LER430
 
  /* IF ERROR, SEND MSG  */
 
     IF COND(%SWITCH(XXXXXX11)) THEN(DO)
 
            SNDPGMMSG  MSG('Job terminated, database in error. +
                           Contact Systems Department.') +
                           TOMSGQ(MOPERQ MRUNQ)
 
     ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
ENDPGM
