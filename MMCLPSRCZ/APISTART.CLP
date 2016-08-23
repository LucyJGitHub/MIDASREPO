/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MM API submit server program')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - API Interface Module                                */
/*                                                                   */
/*       APISTART - Midas API Submit Server Program                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC023             Date 30Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CPK014             Date 14Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/************SBMJOB     CMD(CALL PGM(APISERVER)) JOB(APISERVER) +                         /*CPK014*/
/************             JOBD(*LIBL/APIJOBD)                                             /*CPK014*/
/************SBMJOB     CMD(CALL PGM(APISERVER)) JOB(APISERVER) +                         /*CSC023*/
/************             JOBD(*LIBL/APIJOBD) USER(*JOBD)                      /*CPK014*/ /*CSC023*/
             SBMJOB     CMD(CALL PGM(APISERVER)) JOB(APISERVER) +
                          JOBD(*LIBL/APIJOBD) USER(*JOBD) OUTQ(*JOBD)                     /*CSC023*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
