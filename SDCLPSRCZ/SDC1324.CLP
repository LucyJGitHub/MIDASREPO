/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Call Rep. Struct. Report Prompt')            */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Standing Data Module                        */
/*                                                                   */
/*       SDC1324  - Call to Reporting Structures Report Prompt.      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 053729             DATE 04AUG93              */
/*       PREV AMEND NO. RT0159             DATE 25JUN91              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       053729 - Variable &PARAM should be set up with the report   */
/*                parameter passed into the program, before calling  */
/*                SD1324 with &PARAM as one of the passed parameters.*/
/*  RT0159 - Messages should be sent via new Midas Info Screen.      */
/*                                                                   */
/*********************************************************************/
/**/
     PGM      PARM(&RSEQ &RLEV &RENT &RPARM &RACT &RCMD)
/**/
/**/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RACT)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RCMD)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PARAM) TYPE(*CHAR) LEN(1)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/* Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
/* Set-off Database Error Switches */
/**/
             CHGJOB     SWS(XXXXXX00)
/**/
/* Call Input Cycle Report Program */
/**/
             CHGVAR     VAR(&PARAM) VALUE(%SST(&RPARM 1 1))          /*053729*/
             CALL       PGM(SD1324)  PARM(&RSEQ  &RLEV  &RENT +
                                          &PARAM  &RACT  &RCMD)
/**/
/*  Database Error Messages will be sent by RCF */
/**/
             RTVJOBA    JOB(&JOB) SWS(&SWS)
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
                        CHGVAR     VAR(&RPARM) VALUE(&PARAM)
/**/
             ENDDO
/**/
             GOTO       CMDLBL(END)
/**/
 /***ABNOR:******SNDPGMMSG  MSG('Reporting Structures Report Request +/*RT0159*/
 /***********                ENDED ABNORMALLY') TOPGMQ(*EXT) +        /*RT0159*/
 /***********           TOMSGQ(MOPERQ MRUNQ)                          /*RT0159*/
 ABNOR:                                                               /*RT0159*/
             SNDPGMMSG  MSG('Reporting Structures Report Request +
                          ENDED ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)     /*RT0159*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*RT0159*/
             CALL PGM(SDC0700) PARM('SDC1324' 'RPSRRPTABN' ' ')       /*RT0159*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 END:        ENDPGM
