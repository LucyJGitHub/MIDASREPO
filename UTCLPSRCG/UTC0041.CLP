/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Save current library list')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       UTC0041 - Save Library List                                 */
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
/*                      CSC017 *CREATE     Date 14Feb03              */
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
             PGM        PARM(&SAVDTAL &TEXT)
 
             DCL        VAR(&SAVDTAL) TYPE(*CHAR) LEN(20)
             DCL        VAR(&DTANAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTALIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TEXT) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(2750)
             DCL        VAR(&CURLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(100)
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTQALEN)  TYPE(*DEC) LEN(5) VALUE(10)
             DCL        VAR(&KEY) TYPE(*DEC) LEN(3 0) VALUE(6)
             DCL        VAR(&START) TYPE(*DEC) LEN(3 0) VALUE(1)
             DCL        VAR(&STARTA) TYPE(*CHAR) LEN(3)
             DCL        VAR(&LIBKEY) TYPE(*CHAR) LEN(6)
             DCL        VAR(&LIBNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LOGCLPGM) TYPE(*CHAR) LEN(10)                                /*CPK019*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ABNOR))
 
/* Get user portion of library list and current library */
/**********  RTVJOBA    USRLIBL(&LIBL) CURLIB(&CURLIB)                                 */ /*CPK019*/
             RTVJOBA    LOGCLPGM(&LOGCLPGM) USRLIBL(&LIBL) +
                          CURLIB(&CURLIB)                                                 /*CPK019*/
             CHGJOB     LOGCLPGM(*NO)                                                     /*CPK019*/
 
/* Divide the qualified parameter into the data queue and library names */
             CHGVAR     VAR(&DTANAME) VALUE(%SST(&SAVDTAL 1 10))
             CHGVAR     VAR(&DTALIB) VALUE(%SST(&SAVDTAL 11 10))
 
/* Delete and recreate the temporary data queue */
             DLTDTAQ    DTAQ(&DTALIB/&DTANAME)
             MONMSG     MSGID(CPF0000)
 
             CRTDTAQ    DTAQ(&DTALIB/&DTANAME) MAXLEN(10) SEQ(*FIFO) +
                          TEXT(&TEXT)
 
/* Store the current library as the first entry in the data queue */
             CALL       PGM(QSNDDTAQ) PARM(&DTANAME &DTALIB &DTQALEN +
                          &CURLIB)
 
LIBLLOOP:
/* Retrieve the first user library */
             CHGVAR     VAR(&LIBNAME) VALUE(%SST(&LIBL &START 10))
 
/* If the library name is blank then the last entry has been processed */
             IF         COND(&LIBNAME *EQ '          ') THEN(GOTO +
                          CMDLBL(ENDPGM))
 
/* Copy the user library name to the data queue */
             CALL       PGM(QSNDDTAQ) PARM(&DTANAME &DTALIB &DTQALEN +
                          &LIBNAME)
 
/* Update the next available position in the list of libraries */
             CHGVAR     VAR(&START) VALUE(&START + 11)
 
/* If 250 libraries have been processed then execute the CHGLIBL command */
             IF         COND(&START *GT 2750) THEN(GOTO CMDLBL(ENDPGM))
 
/* Retrieve the next user library */
             GOTO       CMDLBL(LIBLLOOP)
 
             GOTO       CMDLBL(ENDPGM)
 
ABNOR:
             RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGDTA) +
                          MSGID(&MSGID) MSGF(&MSGF) MSGFLIB(&MSGFLIB)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*ESCAPE)
 
ENDPGM:
             CHGJOB     LOGCLPGM(&LOGCLPGM)                                               /*CPK019*/
             MONMSG     MSGID(CPF0000)                                                    /*CPK019*/
             RETURN
 
             ENDPGM
