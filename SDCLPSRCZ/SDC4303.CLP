/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD BTS COB mandatory reporting')                */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Standing Data Module                        */
/*                                                                   */
/*       Business Transaction Statistics Switchable Feature          */
/*                                                                   */
/*       SDC4303  - SD BTS COB Mandatory reporting                   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01411             Date 27Apr93              */
/*                                         Date                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01411 - New program for BTS                                */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/* */
             PGM
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5) VALUE('     ')
             DCL        VAR(&STDT) TYPE(*DEC) LEN(5 0) VALUE(0)
             DCL        VAR(&ENDT) TYPE(*DEC) LEN(5 0) VALUE(0)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*/COPY WNCPYSRC,SDC4303001                                          */
/* */
/** GLOBAL MONITOR MESSAGE */
/* */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/* */
             SNDPGMMSG  MSG('SDC4303 - BTS COB Mandatory +
                          Reporting') TOMSGQ(MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
/* */
/** Set-off Database Error Switches */
/* */
 
             CHGJOB     SWS(XXXXXX00)
/* */
/* Call the Monthly report program */
/* */
             CALL       PGM(SD4301) PARM(&RSEQ &STDT &ENDT)
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               GOTO       CMDLBL(ABNOR)
             ENDDO
/* */
/* Call the Year to date report program */
/* */
             CHGVAR     VAR(&STDT) VALUE(0)
             CHGVAR     VAR(&ENDT) VALUE(0)
             CALL       PGM(SD4302) PARM(&RSEQ &STDT &ENDT)
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               GOTO       CMDLBL(ABNOR)
             ENDDO
/*/COPY WNCPYSRC,SDC4303002                                          */
 
/**/
             GOTO       CMDLBL(END)
 
/* */
/** ABNORMAL ERROR PROCESSING                                      */
/* */
 ABNOR:      SNDPGMMSG  MSG('Program SDC4303 ended abnormally') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
 
/* */
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
