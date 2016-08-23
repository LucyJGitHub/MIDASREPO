/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FC Reports Requested Enquiry')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       FCC2001 - Reports Requested Enquiry                         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BG2193  *CREATE    Date 16Jun04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BG2193 - Viewing of reports in MidasPlus web-facing         */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&USER)
 
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&RTCD)  TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS)  TYPE(*CHAR) LEN(50)
 
             DCL        VAR(&JBNM)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&JUSR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&JBNB)  TYPE(*CHAR) LEN( 6)
 
             DCL        VAR(&RQSQ)  TYPE(*CHAR) LEN( 5)
             DCL        VAR(&TRQSQ) TYPE(*CHAR) LEN( 5)
             DCL        VAR(&INKC)  TYPE(*CHAR) LEN( 1)
             DCL        VAR(&INKL)  TYPE(*CHAR) LEN( 1)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2004')
 
/** GLOBAL MONITOR MESSAGE */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
 
             CHGJOB     SWS(00000000)
 
             DLTF       FILE(QTEMP/QDSPJOB)
             MONMSG CPF0000
             DLTF       FILE(QTEMP/QDSPSPL)
             MONMSG CPF0000
             CRTPF      FILE(QTEMP/QDSPJOB) RCDLEN(150) SIZE(*NOMAX)
             CRTPF      FILE(QTEMP/QDSPSPL) RCDLEN(150) SIZE(*NOMAX)
 
             CHGVAR     VAR(&TRQSQ) VALUE('    ')
 LOOP201:
/* Reports Requested Browse */
             CALL       PGM(FC200001) PARM(&RTCD &ERMS &USER &TRQSQ +
                          &RQSQ &JBNM &JUSR &JBNB &INKC &INKL)
 
/* END */
             IF         COND(&INKC = '1') THEN(GOTO CMDLBL(END))
             IF         COND(&INKL = '1') THEN(GOTO CMDLBL(END))
 
 
             CPYSPLF    FILE(QPDSPJOB) TOFILE(QTEMP/QDSPJOB) +
                          SPLNBR(*LAST)
             DLTSPLF    FILE(QPDSPJOB) SPLNBR(*LAST)
 
/* Job Spooled File Output */
 
             CALL       PGM(FC200002) PARM(&RTCD &ERMS &JBNM &JUSR +
                          &JBNB &INKC &INKL)
 
/* END */
             IF         COND(&INKC = '1') THEN(GOTO CMDLBL(END))
/* ABANDON */
             IF         COND(&INKL = '1') THEN(GOTO CMDLBL(LOOP201))
 
 
             GOTO CMDLBL(LOOP201)
 
 
/** ABNORMAL ERROR PROCESSING                                      */
 ABNOR:      SNDPGMMSG  MSG('PROGRAM FCC2001 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
