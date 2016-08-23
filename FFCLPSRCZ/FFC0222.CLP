/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Submit Input Cycle Revaluations')            */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                    */
/*                                                                   */
/*   FFC0222  -  SUBMIT INPUT CYCLE REVALUATION                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC023             Date 29Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01117             Date 05Jul90              */
/*                      E20718             Date 16Jan90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       S01117 - MULTIBRANCHING                                     */
/*       E20718 - ADD PARMS, RTGDTA(*JOBD) INLLIBL(*JOBD), TO SBMJOB */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/*   DECLARE VARIABLES                                              */
/**/
             DCL        VAR(&PMRKT)   TYPE(*CHAR)  LEN(2)
             DCL        VAR(&PHEAD)   TYPE(*CHAR)  LEN(30)
             DCL        VAR(&SBJOB)   TYPE(*CHAR)  LEN(30)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/*   CALL PROMPT PROGRAM                                            */
/**/
             CHGVAR     VAR(&PHEAD) VALUE('INPUT CYCLE REVALUATION')
             CALL       PGM(FF1265) PARM(&PMRKT &PHEAD)
/*                                                                  */
/* FOR DATABASE ERRORS, GO TO END                                   */
/*                                                                  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO EXIT)
/**/
/***CMD/1*TAKEN,*MARKET*CENTRE*PARAMETER*WILL*BE*'**'***************/ /*S01117*/
/*  CMD/3 TAKEN, MARKET CENTRE PARAMETER WILL BE '03'              */ /*S01117*/
/*  CMD/12 TAKEN, MARKET CENTRE PARAMETER WILL BE '12'             */ /*S01117*/
/**/
/*********** IF         COND(&PMRKT *EQ '**') THEN(GOTO EXIT)      */ /*S01117*/
             IF         COND(&PMRKT *EQ '03') THEN(GOTO EXIT)         /*S01117*/
             IF         COND(&PMRKT *EQ '12') THEN(GOTO EXIT)         /*S01117*/
/**/
/*  SUBMIT INPUT CYCLE REVALUATION                                   */
/**/
             CHGVAR     VAR(&SBJOB) VALUE('CALL FFC0221 PARM(' *CAT +
                          &PMRKT *CAT ')')
             SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)
/************SBMJOB     JOB('RVAL' *CAT &PMRKT) JOBD(MBATCH) +        /*E20718*/
/************             USER(*JOBD) JOBQ(FFJQRV) RQSDTA(&SBJOB) +   /*E20718*/
/************             MSGQ(MOPERQ)                                /*E20718*/
/************SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +      /*E20718*/
/************             JOBQ(FFJQRV) RQSDTA('CALL MIDASRMV') +      /*E20718*/
/************             MSGQ(MOPERQ)                                /*E20718*/
/************SBMJOB     JOB('RVAL' *CAT &PMRKT) JOBD(MBATCH) +                            /*CSC023*/
/************             JOBQ(FFJQRV) USER(*JOBD) RTGDTA(*JOBD) +                        /*CSC023*/
/************             RQSDTA(&SBJOB) INLLIBL(*JOBD) MSGQ(MOPERQ)                      /*CSC023*/
/************SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) JOBQ(FFJQRV) +                         /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                        /*CSC023*/
/************             MIDASRMV') INLLIBL(*JOBD) MSGQ(MOPERQ)                          /*CSC023*/
             SBMJOB     JOB('RVAL' *CAT &PMRKT) JOBD(MBATCH) +
                          JOBQ(FFJQRV) USER(*JOBD) RTGDTA(*JOBD) +
                          RQSDTA(&SBJOB) INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)          /*CSC023*/
             SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) JOBQ(FFJQRV) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          MIDASRMV') INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)              /*CSC023*/
/************                                                         /*E20718*/
/**/
/*  DEALLOCATE THE MARKET DATA AREA                                  */
/**/
             IF         COND(&PMRKT *NE '  ') THEN(DO)
                  DLCOBJ     OBJ((&PMRKT *DTAARA *SHRRD))
                  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
EXIT:        ENDPGM
