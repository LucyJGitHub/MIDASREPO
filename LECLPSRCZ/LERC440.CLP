/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Produce prof file : facility')               */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                     */
/*                                                                   */
/*       LERC440 - Produce report/enq file - FACILITIES              */
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
/*       Last Amend No. 163668             Date 14Jul99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. MOF60              Date 23Mar92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       163668 - Profitability showing on facility customer not on  */
/*                agent customer                                     */
/*       MOF60  - Customer Lending R10 enhancements                  */
/*                                                                   */
/*********************************************************************/
 
PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
     SNDPGMMSG  MSG('Produce Profitability Report/Enquiry file : FACILITIES') +
                                       TOMSGQ(MRUNQ)
 
/* CLEAR OUTPUT FILES */
 
     CLRPFM LENQFCD
     CLRPFM LEPRFCPD                                                  /*163668*/
             CALL       LER441                                        /*163668*/
 
  /* Call Program */
 
             CALL       LER440
 
  /* IF ERROR, SEND MSG  */
 
     IF COND(%SWITCH(XXXXXX11)) THEN(DO)
 
            SNDPGMMSG  MSG('Job terminated, database in error. +
                           Contact Systems Department.') +
                           TOMSGQ(MOPERQ MRUNQ)
 
     ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
ENDPGM
