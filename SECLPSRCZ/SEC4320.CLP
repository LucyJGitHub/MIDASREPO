/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Agency Trade Settlement')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas   - Securities Trading Module                         */
/*                                                                   */
/*       SEC4320 - Agency Trade Settlement                           */
/*                                                                   */
/*       Function: Submit SEC4321                                    */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 02Feb04              */
/*                      CSE039  *CREATE    Date 20Mar03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CSE039 - Automatic Settlement of Trades                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&DTAARA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OWNER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&VAL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
/**  Global Monitor Message                                         */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('SEC4320 - Start Agency Trade Settlem+
                          ent') TOMSGQ(MRUNQ)
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
 
             CHGVAR     VAR(&DMLIB) VALUE(&PREFIX *CAT 'DMLIB')
 
             CHGVAR     VAR(&DTAARA) VALUE('SEC4320')
 
/* Create the job data area if it doesn't already exist  */
 
             CRTDTAARA  DTAARA(&DMLIB/&DTAARA) TYPE(*CHAR) LEN(1)
             MONMSG     MSGID(CPF1023)
 
/* Correct the ownership of the dtaara */
 
             RTVOBJD    OBJ(&DMLIB) OBJTYPE(*LIB) OWNER(&OWNER)
             CHGOBJOWN  OBJ(&DMLIB/&DTAARA) OBJTYPE(*DTAARA) +
                          NEWOWN(&OWNER)
 
             MONMSG     MSGID(CPF0000)
 
             ALCOBJ     OBJ((&DTAARA *DTAARA *EXCL)) WAIT(0)
 
/* If unable to allocate, job is already running */
 
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(END))
             DLCOBJ     OBJ((&DTAARA *DTAARA *EXCL))
 
             RTVDTAARA  DTAARA(&DTAARA) RTNVAR(&VAL)
             IF         COND((%SST(&VAL 1 1)) *NE 'Y') THEN(DO)
 
/************SBMJOB     CMD(CALL PGM(SEC4321) PARM(&DTAARA)) +                            /*CSC023*/
/************             JOB(&DTAARA) JOBD(*LIBL/MBATCH) +                               /*CSC023*/
/************             JOBQ(*LIBL/MEODQ) USER(*JOBD) +                                 /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(*NONE)                                      /*CSC023*/
 
             SBMJOB     CMD(CALL PGM(SEC4321) PARM(&DTAARA)) +
                          JOB(&DTAARA) JOBD(*LIBL/MBATCH) +
                          JOBQ(*LIBL/MEODQ) USER(*JOBD) +
                          INLLIBL(*JOBD) MSGQ(*NONE) OUTQ(*JOBD)                          /*CSC023*/
 
             ENDDO
 
             GOTO       CMDLBL(END)
 
/*     Abnormal termination                                          */
 ABNOR:
 
/* Abnormal termination - batch job */
 
             CHGDTAARA  DTAARA(&DTAARA (1 1)) VALUE('N')
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('SEC4320 - Start Agency Trade Settlem+
                          ent has ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/*     Normal termination                                            */
 END:
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
