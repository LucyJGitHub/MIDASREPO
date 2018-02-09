/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FC Clear output queue MPRINT prompt')           */
/*********************************************************************/
/*                                                                   */
/*  Midas - Report Control Facility Module                           */
/*                                                                   */
/*  FCC0250 - PROMPT TO CLEAR OUTPUT QUEUE MPRINT                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CPK014             Date 14Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      LN0911             Date 23Oct90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       LN0911 - RTGDTA(*JOBD) ADDED TO ALL SBMJOB CMDS.            */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&SYSDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SUBMIT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* RETRIEVE DATE AND CHANGE ITS FORMAT */
/* */
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&SYSDATE)
             CVTDAT     DATE(&SYSDATE) TOVAR(&DATE) FROMFMT(*SYSVAL) +
                          TOFMT(*YMD) TOSEP(*NONE)
/* */
/* CALL PROMPT PROGRAM */
/* */
             CALL       PGM(FC0050) PARM(&DATE &SUBMIT)
/* */
/* SUBMIT CLEAR OF OUTPUT QUEUE IF REQUIRED */
/* */
                                                                      /*LN0911*/
/************IF         COND(&SUBMIT *EQ 'Y') THEN(SBMJOB CMD(CALL +  */
/************             PGM(FCC0255) PARM(&DATE)) JOB(FCC0255) + */
/************             JOBD(MBATCH) PRTDEV(*JOBD) OUTQ(*JOBD) +  */
/************             PRTTXT(*JOBD) SYSLIBL(*CURRENT) +         */
/************             INLLIBL(*JOBD))        */
/************IF         COND(&SUBMIT *EQ 'Y') THEN(SBMJOB CMD(CALL +                      /*CPK014*/
/************             PGM(FCC0255) PARM(&DATE)) JOB(FCC0255) +                        /*CPK014*/
/************             JOBD(MBATCH) PRTDEV(*JOBD) OUTQ(*JOBD) +                        /*CPK014*/
/************             PRTTXT(*JOBD) SYSLIBL(*CURRENT) +                               /*CPK014*/
/************             RTGDTA(*JOBD) INLLIBL(*JOBD))                                   /*CPK014*/
                                                                      /*LN0911*/
             IF         COND(&SUBMIT *EQ 'Y') THEN(SBMJOB CMD(CALL +
                          PGM(FCC0255) PARM(&DATE)) JOB(FCC0255) +
                          JOBD(MBATCH) PRTDEV(*JOBD) OUTQ(*JOBD) +
                          USER(*JOBD) PRTTXT(*JOBD) RTGDTA(*JOBD) +
                          SYSLIBL(*CURRENT) INLLIBL(*JOBD))                               /*CPK014*/
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
