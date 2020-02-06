/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GO Journal Entry Extraction Control')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOC0304 - Journal Entry Extraction Control                  */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BUG18886           Date 30May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CGP004  *CREATE    Date 23May03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG18886 - Non-standard codes exist in Midas Plus core      */
/*                  sources                                          */
/*       CGP004 - Audit Reporting                                    */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&RTCD)  TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS)  TYPE(*CHAR) LEN(50)
 
             DCL        VAR(&FULLCHECK) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&ZOZONE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&ZOSHTC)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&ZORDNB)  TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&ZODNWD)  TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&ZOBCCY)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&ZONJOB)  TYPE(*DEC)  LEN(1 0)
 
             DCL        VAR(&RCV)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&CDAT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&FENT) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&TENT) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&LENT) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
/** GLOBAL MONITOR MESSAGE */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Change Date Format to be DDMMYY */
             CHGJOB     DATFMT(*DMY)
 
 
             CHGJOB     SWS(00000000)
 
/* Get zone */
             CALL       PGM(GOGETZONE) PARM(&RTCD &ERMS &FULLCHECK +
                          &ZOZONE &ZOSHTC &ZORDNB &ZODNWD &ZOBCCY +
                          &ZONJOB)
/* error */
/**********  IF         COND(&RTCD *= '       ') THEN(DO)                            */ /*BUG18886*/
             IF         COND(&RTCD *NE '       ') THEN(DO)                              /*BUG18886*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
 
/* Journal Receiver Chain Retrieval */
 
LOOP:        CALL       PGM(GOC0305) PARM(&ZOZONE &RCV &CDAT &FENT +
                          &TENT &LENT)
             IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
             IF         COND(&RCV = '          ') THEN(GOTO +
                          CMDLBL(END))
 
/* Extraction of Journal Entries */
 
             CALL       PGM(GOC0306) PARM(&ZOZONE &RCV &CDAT &FENT +
                          &TENT &LENT)
             IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
             GOTO       CMDLBL(LOOP)
 
 
/** ABNORMAL ERROR PROCESSING  */
 
 ABNOR:      SNDPGMMSG  MSG('PROGRAM GOC0304 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
