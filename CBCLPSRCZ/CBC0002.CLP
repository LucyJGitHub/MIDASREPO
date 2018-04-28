/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas COB Check Status for scheduled jobs')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Module                            */
/*                                                                   */
/*       CBC0002 - Check Status for Schedule job                     */
/*                                                                   */
/*       Function: This program checks the Status of the actual COB  */
/*                 Scheduled job.                                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CCB014  *Create    Date 25Apr05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CCB014 - Pre-Scheduled Batch Close Of Business              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/* INPUT :                                                           */
/*   &JOBNAME, &JOBUSER, &JOBNUMB                                    */
/*                                                                   */
/* OUTPUT :                                                          */
/*   &JOBSTS  Job status                                             */
/*              - *ACTIVE, *JOBQ, *OUTQ                              */
/*   &JOBSTSQ Status of job on the job queue                         */
/*              - SCD, HLD, RLS                                      */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&JOBNAME &JOBUSER &JOBNUMB &JOBSTS +
                          &JOBSTSQ)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
 
             DCL        VAR(&JOBD) TYPE(*CHAR) LEN(188)
             DCL        VAR(&JOBNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNUMB) TYPE(*CHAR) LEN(6)
             DCL        VAR(&JOBQUAL) TYPE(*CHAR) LEN(26)
             DCL        VAR(&JOBSTS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBSTSQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&INTJBNB) TYPE(*CHAR) LEN(16)
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ENDPGM))
 
             CHGVAR     VAR(%SST(&JOBQUAL 1 10)) VALUE(&JOBNAME)
             CHGVAR     VAR(%SST(&JOBQUAL 11 10)) VALUE(&JOBUSER)
             CHGVAR     VAR(%SST(&JOBQUAL 21 6)) VALUE(&JOBNUMB)
 
             CALL       PGM(QUSRJOBI) PARM(&JOBD X'00000188' +
                          'JOBI0300' &JOBQUAL &INTJBNB)
             MONMSG     MSGID(CPF0000) EXEC(DO)
               CHGVAR     VAR(&JOBSTS) VALUE('*OUTQ')
               GOTO       CMDLBL(ENDPGM)
             ENDDO
 
             CHGVAR     VAR(&JOBSTS) VALUE(%SST(&JOBD 51 10))
             CHGVAR     VAR(&JOBSTSQ) VALUE(%SST(&JOBD 163 10))
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
 
 ENDPGM:     ENDPGM
