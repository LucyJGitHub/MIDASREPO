/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Clear Program Subfile Message queue')        */
/*********************************************************************/
/*                                                                  */
/*       Midas     - Customer Lending Module                    */
/*                                                                  */
/*       GPCLRM - Add Message to message file                       */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. XXXXXX            DATE  DDMMMYY             */
/*                                                                  */
/********************************************************************/
/*       XXXXXX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX        */
/********************************************************************/
     PGM
     DCL VAR(&VERS) TYPE(*CHAR) LEN(8) VALUE('00.00.00')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
     RMVMSG PGMQ(*PRV) CLEAR(*ALL)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
     ENDPGM
