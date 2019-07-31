/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CF End MIDAS/TRAM Interface Control')           */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  CONFIRMATION MATCHING                         */
/*                                                                   */
/*   CFCONTEND  -  END MIDAS/TRAM INTERFACE CONTROL                  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01304             Date 21May91              */
/*                      E00000             Date 00Xxx00              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*   S01304 - R10 INCORPORATION CHANGES                              */
/*                                                                   */
/*********************************************************************/
   PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/************ENDJOB     JOB(CFCONTROL) OPTION(*IMMED)                  S01304*/
             CALL       PGM(QSNDDTAQ) PARM(CFDTQZ *LIBL X'00001F' Y) /*S01304*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
   ENDPGM
 
