/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Check object lock status')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC0520 - Check Object Lock Status for Database Updaters    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Last Amend No. 201589  *CREATE    Date 03Jan02              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       201589 - New module created for this change.                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&OBJECT &LIBRARY &OBJTYPE &LOCKSTATE +
                          &MEMBER &ENDJOB &RETURN)
 
/*/COPY WNCPYSRC,SCC0520INT                                          */
 
             DCL        VAR(&OBJECT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBRARY) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJTYPE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&LOCKSTATE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WAITTIME) TYPE(*CHAR) LEN(6) VALUE('000001')
             DCL        VAR(&ENDJOB) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2002')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,SCC0520MPS                                          */
 
/* Attempt to allocate the *LCK dtaara exclusively */
 
             ALCOBJ     OBJ((&LIBRARY/&OBJECT &OBJTYPE &LOCKSTATE)) +
                          WAIT(&WAITTIME)
             MONMSG     MSGID(CPF1002) EXEC(CHGVAR VAR(&RETURN) +
                          VALUE('NO_ALC'))
 
/* If the return code is not blank then the allocation failed */
/* If the allocation failed and the end job indicator is 'Y'  */
/* then end the job immediately by rerouting it.              */
 
             IF         COND((&RETURN *NE ' ') *AND (&ENDJOB *EQ +
                          'Y')) THEN(DO)
                CHGJOB     LOG(*SAME *SAME *NOLIST)
                TFRJOB     JOBQ(INTERFACE)
             ENDDO
 
/*/COPY WNCPYSRC,SCC0520MPE                                          */
 
             GOTO       CMDLBL(END)
 
ABNOR:
/*/COPY WNCPYSRC,SCC0520ERR                                          */
 
/* Abnormal termination */
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SCC0520 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,SCC0520END                                          */
 
             ENDPGM
