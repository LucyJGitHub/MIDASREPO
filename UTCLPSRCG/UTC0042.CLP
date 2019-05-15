/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Restore library list')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       UTC0042 - Restore Library List                              */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK019             Date 13Jul04              */
/*                      CPK018             Date 23Apr04              */
/*                      CSC017  *CREATE    Date 14Feb03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK019 - Stop logging CL commands to lessen job log.        */
/*       CPK018 - MidasPlus packaging.  Moved to global layer.       */
/*       CSC017 - Program re-written to allow it to work in both the */
/*                25 and 250 library list environment.               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SAVEDLIBL)
 
             DCL        VAR(&SAVEDLIBL) TYPE(*CHAR) LEN(20)
             DCL        VAR(&DTANAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTALIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WAIT) TYPE(*DEC) LEN(5 0) VALUE(0)
             DCL        VAR(&CURLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTQALEN)  TYPE(*DEC) LEN(5) VALUE(10)
             DCL        VAR(&LIBNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBREF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(2750)
             DCL        VAR(&CMD) TYPE(*CHAR) LEN(2782)
             DCL        VAR(&START) TYPE(*DEC) LEN(3 0) VALUE(1)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(100)
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LOGCLPGM) TYPE(*CHAR) LEN(10)                                /*CPK019*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
             MONMSG     MSGID(MCH0000 SYS0000 CPF0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Retrieve CL logging level for job. */                                                  /*CPK019*/
             RTVJOBA    LOGCLPGM(&LOGCLPGM)                                               /*CPK019*/
             CHGJOB     LOGCLPGM(*NO)                                                     /*CPK019*/
 
/* Divide the qualified parameter into the data queue and library names */
             CHGVAR VAR(&DTANAME) VALUE(%SST(&SAVEDLIBL 1 10))
             CHGVAR VAR(&DTALIB) VALUE(%SST(&SAVEDLIBL 11 10))
 
/* Delete and recreate the temporary holding data queue */
             DLTDTAQ    DTAQ(&DTALIB/RTVDTAQ)
             MONMSG     MSGID(CPF0000)
 
             CRTDTAQ    DTAQ(&DTALIB/RTVDTAQ) MAXLEN(10) SEQ(*FIFO) +
                          TEXT('RTVDTAQ utility holding DTAQ')
 
/* Read the first entry from the data queue (current library) */
             CALL       PGM(QRCVDTAQ) PARM(&DTANAME &DTALIB &DTQALEN +
                          &CURLIB &WAIT)
 
/* Write the current library to the holding data queue for later use */
             CALL       PGM(QSNDDTAQ) PARM('RTVDTAQ' &DTALIB &DTQALEN +
                          &CURLIB)
 
/* If there was not originally a current library then change the value */
/* to the CHGLIBL setting of *CRTDFT.                                  */
             IF         COND(&CURLIB *EQ '*NONE') THEN(CHGVAR +
                          VAR(&CURLIB) VALUE('*CRTDFT'))
 
/* Main loop to build up the list of libraries */
 
LIBLLOOP:
/* Read the next entry from the data queue */
             CALL       PGM(QRCVDTAQ) PARM(&DTANAME &DTALIB &DTQALEN +
                          &LIBNAME &WAIT)
 
/* If the library name is the same as for the last run then the last */
/* entry has been extracted. Drop out and execute CHGLIBL.           */
             IF         COND(&LIBNAME *EQ &LIBREF) THEN(GOTO +
                          CMDLBL(RESET))
 
/* Save the library name for later comparison */
             CHGVAR     VAR(&LIBREF) VALUE(&LIBNAME)
 
/* Update the next available position in the list of libraries */
             CHGVAR     VAR(%SST(&LIBL &START 10)) VALUE(&LIBNAME)
 
/* Write the library to the holding data queue for later use */
             CALL       PGM(QSNDDTAQ) PARM('RTVDTAQ' &DTALIB &DTQALEN +
                          &LIBNAME)
 
/* Increment the next available position on the library list string */
             CHGVAR     VAR(&START) VALUE(&START + 11)
 
/* If 250 libraries have been processed then execute the CHGLIBL command */
             IF         COND(&START *GT 2750) THEN(GOTO CMDLBL(RESET))
 
/* Read the next entry from the data queue */
             GOTO       CMDLBL(LIBLLOOP)
 
RESET:
/* Build the CHGLIBL command from the variables build up earlier */
             CHGVAR     VAR(&CMD) VALUE('CHGLIBL LIBL(' *CAT &LIBL +
                          *TCAT ') CURLIB(' *CAT &CURLIB *CAT ')')
 
/* Change the library list */
             CALL       PGM(QCMDEXC) PARM(&CMD 2782)
 
/* Initialise the start position for the reset of the original data queue */
             CHGVAR     VAR(&START) VALUE(001)
 
LIBLLOOP2:
/* Read the next entry from the holding data queue */
             CALL       PGM(QRCVDTAQ) PARM('RTVDTAQ' &DTALIB &DTQALEN +
                          &LIBNAME &WAIT)
 
/* If the library name is the same as for the last run then the last */
/* entry has been extracted. Drop out and end the program.           */
             IF         COND(&LIBNAME *EQ &LIBREF) THEN(GOTO +
                          CMDLBL(ENDPGM))
 
/* Save the library name for later comparison */
             CHGVAR     VAR(&LIBREF) VALUE(&LIBNAME)
 
/* Write the library to the original data queue */
             CALL       PGM(QSNDDTAQ) PARM(&DTANAME &DTALIB &DTQALEN +
                          &LIBNAME)
 
/* Increment the next available position on the library list string */
             CHGVAR     VAR(&START) VALUE(&START + 11)
 
/* If 250 libraries have been processed then end the program */
             IF         COND(&START *GT 2750) THEN(GOTO CMDLBL(ENDPGM))
 
/* Read the next entry from the holding data queue */
             GOTO       CMDLBL(LIBLLOOP2)
 
             GOTO       CMDLBL(ENDPGM)
 
ABNOR:
             RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGDTA) +
                          MSGID(&MSGID) MSGF(&MSGF) MSGFLIB(&MSGFLIB)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*ESCAPE)
             SNDPGMMSG  MSG('RSTLIBL ended in error')
             MONMSG     MSGID(CPF0000)
 
ENDPGM:
             CHGJOB     LOGCLPGM(&LOGCLPGM)                                               /*CPK019*/
             MONMSG     MSGID(CPF0000)                                                    /*CPK019*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             RETURN
 
             ENDPGM
