000100200318/*********************************************************************/
000200200318/*STD    CLPBASE                                                     */
000300200318/*EXI    TEXT('Midas FC Reports Requested Enquiry')                  */
000400200318/*********************************************************************/
000500200318/*                                                                   */
000600200318/*       Midas - Global Processing Module                            */
000700200318/*                                                                   */
000800200318/*       FCC2001A - Reports Requested Enquiry                        */
000900200318/*                                                                   */
001000200318/*       (c) Misys International Banking Systems Ltd. 2007           */
001100200318/*                                                                   */
001200200604/*       Last Amend No. 248899  *CREATE    Date 22May20              */
001300200318/*                                                                   */
001400200318/*********************************************************************/
001500200318/*                                                                   */
001600200318/*       248899 - Restored the use of FC0060.  Applied fix 245733.   */
001700200318/*                                                                   */
001800200318/*********************************************************************/
001900200318             PGM        PARM(&JBNM &JUSR &JBNB)
002000200318             DCL        VAR(&RTCD)  TYPE(*CHAR) LEN( 7)
002100200318             DCL        VAR(&ERMS)  TYPE(*CHAR) LEN(50)
002200200318             DCL        VAR(&JBNM)  TYPE(*CHAR) LEN(10)
002300200318             DCL        VAR(&JUSR)  TYPE(*CHAR) LEN(10)
002400200318             DCL        VAR(&JBNB)  TYPE(*CHAR) LEN( 6)
002500200318             DCL        VAR(&INKC)  TYPE(*CHAR) LEN( 1)
002600200318             DCL        VAR(&INKL)  TYPE(*CHAR) LEN( 1)
002700200318             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
002800200318                          Misys International Banking Systems Ltd. +
002900200318                          2007')
003000200318/** GLOBAL MONITOR MESSAGE */
003100200318             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
003200200318                          CMDLBL(ABNOR))
003300200318             CHGJOB     SWS(00000000)
003400200318             DLTF       FILE(QTEMP/QDSPJOB)
003500200318             MONMSG CPF0000
003600200318             DLTF       FILE(QTEMP/QDSPSPL)
003700200318             MONMSG CPF0000
003800200318             CRTPF      FILE(QTEMP/QDSPJOB) RCDLEN(150) SIZE(*NOMAX)
003900200318             CRTPF      FILE(QTEMP/QDSPSPL) RCDLEN(150) SIZE(*NOMAX)
004000200318             WRKJOB     JOB(&JBNB/&JUSR/&JBNM) OUTPUT(*PRINT) +
004100200318                          OPTION(*SPLF)
004200200318             CPYSPLF    FILE(QPDSPJOB) TOFILE(QTEMP/QDSPJOB) JOB(*) +
004300200318                          SPLNBR(*LAST)
004400200318             DLTSPLF    FILE(QPDSPJOB) SPLNBR(*LAST)
004500200318/* Job Spooled File Output */
004600200318             CALL       PGM(FC200002) PARM(&RTCD &ERMS &JBNM &JUSR +
004700200318                          &JBNB &INKC &INKL)
004800200318             GOTO CMDLBL(END)
004900200318/** ABNORMAL ERROR PROCESSING                                      */
005000200318 ABNOR:      SNDPGMMSG  MSG('PROGRAM FCC2001 ENDED ABNORMALLY') +
005100200318                          TOMSGQ(MOPERQ)
005200200318             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
005300200318             CHGJOB     SWS(XXXXXX11)
005400200318
005500200318END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
005600200318                          Misys International Banking Systems Ltd.')
005700200318             ENDPGM
