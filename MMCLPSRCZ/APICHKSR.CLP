/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas API Check active servers')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas - API Interface Module                                */
/*                                                                   */
/*       APIJOBCHK - Midas API Check active job                      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. XNNNNN  *CREATE    Date DDMmmYY              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       Xnnnnn - (fix description)                                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&NAME &USER &NUMBER &RETURN)
 
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NUMBER) TYPE(*CHAR) LEN(6)
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             CHGVAR     VAR(&RETURN) VALUE('0')
 
/* Check job */
             CHGJOB     JOB(&NUMBER/&USER/&NAME) JOBPTY(5)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&RETURN) +
                          VALUE('1'))
 
             RCVMSG     MSGQ(*PGMQ) MSGID(&MSGID) MSGF(&MSGF)
 
             IF         COND(&MSGID *EQ 'CPF1290') THEN(CHGVAR +
                          VAR(&RETURN) VALUE('1'))
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
