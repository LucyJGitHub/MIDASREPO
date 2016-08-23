/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CF End MIDAS/TRAM Interface Control')           */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  CONFIRMATION MATCHING                         */
/*                                                                   */
/*   CFCONTEND  -  END MIDAS/TRAM INTERFACE CONTROL                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   LAST AMEND NO. S01304            DATE 21MAY91                   */
/*   PREV AMEND NO. E00000            DATE 00XXX00                   */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*   S01304 - R10 INCORPORATION CHANGES                              */
/*                                                                   */
/*********************************************************************/
   PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/************ENDJOB     JOB(CFCONTROL) OPTION(*IMMED)                  S01304*/
             CALL       PGM(QSNDDTAQ) PARM(CFDTQZ *LIBL X'00001F' Y) /*S01304*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
   ENDPGM
 
