/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Check success of selected option')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       UTC0931 - Check Success of Selected Option.                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CUP004  *CREATE    Date 13MAY98              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUP004 - Make upgrade of DTALIB items easier                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&U7 &U8)
 
             DCL        VAR(&JOBSWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&U7) TYPE(*CHAR) LEN(1)
             DCL        VAR(&U8) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
 
/* Retrieve the job switches */
             RTVJOBA    SWS(&JOBSWS)
 
/* Move U7 and U8 to the output parameter variables */
             CHGVAR     VAR(&U7) VALUE(%SST(&JOBSWS 7 1))
 
             CHGVAR     VAR(&U8) VALUE(%SST(&JOBSWS 8 1))
 
/* Set U7 and U8 off */
             CHGJOB     SWS(XXXXXX00)
 
             GOTO       CMDLBL(ENDPGM)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
