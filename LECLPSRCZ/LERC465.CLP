/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Merge profitability files')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                     */
/*                                                                   */
/*       LERC465 - Merge all profitability report/enq files          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*                                                                   */
/*       Last Amend No. AR1089839          Date 19Feb13              */
/*       Prev Amend No. CLE075AL           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      MOF60              DATE 23MAR92              */
/*                                         DATE ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR1089839 - COBOP and 2.1 source clashes                    */
/*       CLE075AL - COB Restructure - LE COB Optimisation Phase 1    */
/*       MOF60  - Customer Lending R10 enhancements                  */
/*                                                                   */
/*********************************************************************/
 
PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
     SNDPGMMSG  MSG('Merge Profitability Report/Enquiry files') +
                                       TOMSGQ(MRUNQ)
 
/* CLEAR OUTPUT FILES */
 
     CLRPFM LENQ
 
  /**Call*Program*****************************************************/                 /*CLE075AL*/
 
  /**********CALL       LENQCPY                                      */                 /*CLE075AL*/
 
  /**IF*ERROR,*SEND*MSG***********************************************/       /*CLE075AL AR1089839*/
 
  /**IF*COND(%SWITCH(XXXXXX11)) THEN(DO)                             */                 /*CLE075AL*/
 
  /*********SNDPGMMSG  MSG('Job terminated, database in error. +
                           Contact Systems Department.') +
                           TOMSGQ(MOPERQ MRUNQ)                      */                 /*CLE075AL*/
 
  /**ENDDO**                                                         */                 /*CLE075AL*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
ENDPGM
