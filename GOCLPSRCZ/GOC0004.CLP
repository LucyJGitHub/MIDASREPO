/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GO Universal Transactions Updater Submission')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOC0004 - Universal Transactions Updater Submission         */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK019             Date 24Jun04              */
/*                      CSC023             Date 29Jan04              */
/*                      CGP001  *CREATE    Date 23May03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK019 - SBMJOB does  not work if &ZONE uses all 10         */
/*                characters.                                        */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CGP001 - Global Processing                                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&ZONE &MSYS &JNSF &ZDTQ)
 
             DCL        VAR(&ZONE)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSYS)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&JNSF)   TYPE(*CHAR) LEN(5)
             DCL        VAR(&ZDTQ)   TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&JOBN)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBR)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&RQSD)   TYPE(*CHAR) LEN(80)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&JOBN) VALUE('GPUTU' *CAT &JNSF)
             CHGVAR     VAR(&LIBR) VALUE(&MSYS *CAT 'XLIB')
/**********  CHGVAR     VAR(&RQSD) VALUE('CALL GOC0005   PARM(' *CAT +                 */ /*CPK019*/
/**********               &ZONE *CAT 'GPUTU' *CAT &JNSF *CAT ')')                      */ /*CPK019*/
             CHGVAR     VAR(&RQSD) VALUE('CALL GOC0005   PARM(' *CAT +
                          &ZONE *BCAT 'GPUTU' *CAT &JNSF *CAT ')')                        /*CPK019*/
 
/************SBMJOB     JOB(&JOBN) JOBD(&LIBR/MBATCH) JOBQ(GPUTUJOBQ) +                   /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA(&RQSD) +                       /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(&LIBR/MOPERQ)                               /*CSC023*/
             SBMJOB     JOB(&JOBN) JOBD(&LIBR/MBATCH) JOBQ(GPUTUJOBQ) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA(&RQSD) +
                          INLLIBL(*JOBD) MSGQ(&LIBR/MOPERQ) OUTQ(*JOBD)                   /*CSC023*/
             MONMSG     MSGID(CPF0000)
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
/* Abnormal termination */
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
