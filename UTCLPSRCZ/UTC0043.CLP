/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Apply JOBD library list to current job')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       UTC0043 - Apply library list from a job description to      */
/*                 current job                                       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC017  *CREATE    Date 14Feb03              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC017 - Change to 250 library list.                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&JOBDFULL)
 
             DCL        VAR(&JOBDFULL) TYPE(*CHAR) LEN(20)
             DCL        VAR(&JOBD) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBDLB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&INLLIBL) TYPE(*CHAR) LEN(2750)
             DCL        VAR(&CMD) TYPE(*CHAR) LEN(2764)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Split qualified JOBD string into its component parts */
             CHGVAR     VAR(&JOBD) VALUE(%SST(&JOBDFULL 1 10))
             CHGVAR     VAR(&JOBDLB) VALUE(%SST(&JOBDFULL 11 10))
 
/* Retrieve the initial library list from the specified job description */
             RTVJOBD    JOBD(&JOBDLB/&JOBD) INLLIBL(&INLLIBL)
 
/* Apply the retrieved library list to the current job */
             CHGVAR     VAR(&CMD) VALUE('CHGLIBL LIBL(' *CAT +
                          &INLLIBL *CAT ')')
 
             CALL       PGM(QCMDEXC) PARM(&CMD 2764)
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          UTC0043 ended abnormally.  See joblog for +
                          more details') TOPGMQ(*PRV) MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
