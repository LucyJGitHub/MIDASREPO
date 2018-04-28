/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL RESET GL FILE INDS')                         */
/********************************************************************/
/*                                                                  */
/*        Midas     - General Ledger Module                     */
/*                                                                  */
/*       GLC50A - RESET GL REPORTING FILE INDICATORS                */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01369         DATE  06APR92                */
/*       PREV AMEND NO.                DATE                         */
/*                                                                  */
/********************************************************************/
/*       S01369  -  Allow user to request on request GL balance     */
/*                  reports after POST 1,2,4,3, and 5. Pos 41 on    */
/*                  GLSTAT is set to 'N' by the individual GL       */
/*                  posting runs.                                   */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&GLSTAT)   TYPE(*CHAR) LEN(256)
/**/
             SNDPGMMSG  MSG('GLC50A - RESET GL REPORTING FILE INDICATORS') +
                        TOMSGQ(MRUNQ)
             RTVDTAARA  DTAARA(GLSTAT) RTNVAR(&GLSTAT)
/**/
/**********  CHGVAR     VAR(%SUBSTRING(&GLSTAT 41 1)) VALUE('N')   */ /*S01369*/
/**/
             CHGVAR     VAR(%SUBSTRING(&GLSTAT 46 3)) VALUE('NNN')
/**/
             CHGDTAARA  DTAARA(GLSTAT) VALUE(&GLSTAT)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
