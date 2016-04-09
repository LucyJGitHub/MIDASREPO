/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD BTS year-to-date report (request)')          */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Standing Data Module                        */
/*                                                                   */
/*       Business Transaction Statistics Switchable Feature          */
/*                                                                   */
/*       SDC4302  - SD BTS Year-to-date reporting (on request)       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01411             DATE 27APR93              */
/*       PREV AMEND NO.                    DATE                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01411 - New program for BTS                                */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/* */
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&STDT) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&ENDT) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*/COPY WNCPYSRC,SDC4302001                                          */
/* */
/** GLOBAL MONITOR MESSAGE */
/* */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/* */
/** Set-off Database Error Switches */
/* */
 
             CHGJOB     SWS(XXXXXX00)
/* */
/** Determine start date, characters 1-5 of Prompt parameter */
/* */
             CHGVAR     VAR(&STDT) VALUE(%SUBSTRING(&RPARM 1 5))
/* */
/** Determine end date, characters 6-10 of Prompt parameter */
/* */
             CHGVAR     VAR(&ENDT) VALUE(%SUBSTRING(&RPARM 6 5))
/* */
/* Call the Year to date report program */
/* */
             CALL       PGM(SD4302) PARM(&RSEQ &STDT &ENDT)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
/*/COPY WNCPYSRC,SDC4302002                                          */
 
/**/
             GOTO       CMDLBL(END)
 
/* */
/** ABNORMAL ERROR PROCESSING                                      */
/* */
 ABNOR:      SNDPGMMSG  MSG('Program SDC4302 ended abnormally') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/* */
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
