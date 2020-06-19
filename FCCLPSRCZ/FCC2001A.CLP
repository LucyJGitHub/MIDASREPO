/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas FC Reports Requested Enquiry')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       FCC2001A - Reports Requested Enquiry                        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2007           */
/*                                                                   */
/*       Last Amend No. 248899  *CREATE    Date 22May20              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       248899 - Restored the use of FC0060.  Applied fix 245733.   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&JBNM &JUSR &JBNB)
             DCL        VAR(&RTCD)  TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&JBNM)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&JUSR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&JBNB)  TYPE(*CHAR) LEN( 6)
             DCL        VAR(&INKC)  TYPE(*CHAR) LEN( 1)
             DCL        VAR(&INKL)  TYPE(*CHAR) LEN( 1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2007')
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
             WRKJOB     JOB(&JBNB/&JUSR/&JBNM) OUTPUT(*PRINT) +
                          OPTION(*SPLF)
             CPYSPLF    FILE(QPDSPJOB) TOFILE(QTEMP/QDSPJOB) JOB(*) +
                          SPLNBR(*LAST)
             DLTSPLF    FILE(QPDSPJOB) SPLNBR(*LAST)
/* Job Spooled File Output */
             CALL       PGM(FC200002) PARM(&RTCD &ERMS &JBNM &JUSR +
                          &JBNB &INKC &INKL)
             GOTO CMDLBL(END)
/** ABNORMAL ERROR PROCESSING                                      */
 ABNOR:      SNDPGMMSG  MSG('PROGRAM FCC2001 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)

END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
