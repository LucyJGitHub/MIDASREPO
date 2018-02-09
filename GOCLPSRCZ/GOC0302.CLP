/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GO Journal Entry Extraction Monitor')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOC0302 - Journal Entry Extraction Monitor                  */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG2941            Date 01Jun04              */
/*                      BG1928             Date 15Apr03              */
/*                      CGP004  *CREATE    Date 23May03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG2941 - Parameter mismatch error.  Need to redeliver      */
/*                 BUG1928 (sources GOC0302 and GOC0303 only).       */
/*       BG1928 - Audit deliverable data missing                     */
/*       CGP004 - Audit Reporting                                    */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
             DCLF       FILE(GOICDTPD)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             ALCOBJ     OBJ((GOAUMTDQ *DTAQ *EXCLRD)) WAIT(30)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
             SNDPGMMSG  MSG('Attempt to start Journal Entry +
                          Extraction Monitor has failed. Probable +
                          cause: process is active already.') +
                          TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             CHGJOB SWS(00000000)
 
 READ:       RCVF
/* EOF. Goto abnormal processing section */
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ABNOR))
 
/* Default wait-time is 600 seconds */
 
             IF         COND(&ZNAUWT = 0) THEN(CHGVAR VAR(&ZNAUWT) +
                          VALUE(600))
 
/* Journal Receiver Chain Refresh*/
 
/*********** CALL       PGM(GOC0303) *******************************************/         /*BG1928*/
             CALL       PGM(GOC0303) PARM('N')                                            /*BG1928*/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
/* Extract */
             CALL       PGM(GOC0304)
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
               GOTO       CMDLBL(ABNOR)
             ENDDO
 
 RETRY:      CALL       PGM(QRCVDTAQ) PARM(GOAUMTDQ *LIBL X'00001F' +
                          &RETURN &ZNAUWT)
 
             IF         COND(&RETURN *NE 'T') THEN(DO)
 
/* Journal Receiver Chain Refresh*/
 
/*********** CALL       PGM(GOC0303) *******************************************/         /*BG1928*/
             CALL       PGM(GOC0303) PARM('N')                                            /*BG1928*/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
/* Extract */
               CALL       PGM(GOC0304)
               IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                 GOTO       CMDLBL(ABNOR)
               ENDDO
             GOTO       CMDLBL(RETRY)
             ENDDO
 
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
/* Abnormal termination */
 
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          GOC0302 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             DLCOBJ     OBJ((GOAUMTDQ *DTAQ *EXCLRD))
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
             ENDPGM
