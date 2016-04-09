/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FC Submit RCF monitor')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Report Control Facility                         */
/*                                                                   */
/*       FCC0400 - Sumit RCF Monitor                                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Last Amend No. CPK014             Date 14Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC001             Date 04APR95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       CSC001 - Move start to after ICIFINISH                      */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global Monitor Message */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
 
/**/
/* If background RCF distribution program is not already running   */
/* start it up                                                     */
/* */
             ALCOBJ     OBJ((FC0100 *DTAARA *EXCL)) WAIT(0)
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(ENDCLPGM))
             DLCOBJ     OBJ((FC0100 *DTAARA *EXCL))
/************SBMJOB     CMD(CALL PGM(FCC0401) PARM(I)) +                                  /*CPK014*/
/************             JOB(RCFMONITOR) JOBD(FCJOBD) JOBQ(FCJOBQ) +                     /*CPK014*/
/************             OUTQ(*JOBD) INLLIBL(*JOBD) RTGDTA(*JOBD)                        /*CPK014*/
             SBMJOB     CMD(CALL PGM(FCC0401) PARM(I)) +
                          JOB(RCFMONITOR) JOBD(FCJOBD) JOBQ(FCJOBQ) +
                          OUTQ(*JOBD) USER(*JOBD) RTGDTA(*JOBD) +
                          INLLIBL(*JOBD)                                                  /*CPK014*/
/* */
             GOTO       CMDLBL(ENDCLPGM)
/* */
/* Abnormal termination processing */
ABNORMAL:
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             SNDPGMMSG  MSG('Program FCC0400 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          FCC0400 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/* End program */
 ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             ENDPGM
