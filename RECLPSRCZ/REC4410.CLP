/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE CI comms program error handler control')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail  Module                                      */
/*                                                                   */
/*       REC4410 - CI Comms Program Error Handler Control            */
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
/*       Prev Amend No. 118134             Date 02Jun97              */
/*                      CRT003  *CREATE    Date 22JUL96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       118134 - Correct ABNOR processing to ensure termination.    */
/*       CRT003 - Branch Automation Interface.                       */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG(MIDAS) TOMSGQ(MSTATUS)
 
/************SBMJOB     CMD(CALL PGM(REC4411) PARM(' ' ' ' ' ' ' ' ' +                    /*CPK014*/
/************             ' ' ')) JOB(REC4411) JOBD(MBATCH) +                             /*CPK014*/
/************             OUTQ(*JOBD) RTGDTA(*JOBD)                                       /*CPK014*/
 
/************SBMJOB     CMD(CALL PGM(MIDASRMV)) JOB(MIDASRMV) +                           /*CPK014*/
/************             JOBD(MBATCH) OUTQ(*JOBD) RTGDTA(*JOBD)                          /*CPK014*/
             SBMJOB     CMD(CALL PGM(REC4411) PARM(' ' ' ' ' ' ' ' ' +
                          ' ' ')) JOB(REC4411) JOBD(MBATCH) +
                          OUTQ(*JOBD) USER(*JOBD) RTGDTA(*JOBD)
 
             SBMJOB     CMD(CALL PGM(MIDASRMV)) JOB(MIDASRMV) +
                          JOBD(MBATCH) OUTQ(*JOBD) USER(*JOBD) +
                          RTGDTA(*JOBD)                                                   /*CPK014*/
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG  MSG('CI Comms Program Errors Report Ended +
                          Abnormally') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF2469)  EXEC(DO)                      /*118134*/
                SNDPGMMSG  MSG('CI Comms Program Errors Report Ended +
                             Abnormally') TOMSGQ(QSYSOPR)             /*118134*/
             ENDDO                                                    /*118134*/
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
