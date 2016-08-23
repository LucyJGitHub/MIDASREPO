/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RR Submit auto backup')                         */
/*********************************************************************/
/*                                                                   */
/*        Midas - Restart Recovery Module                            */
/*                                                                   */
/*       SDC1760 - SUBMIT AUTO BACKUP                                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC023             Date 30Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CPK014             Date 14Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408        Date 10May95                   */
/*                      081177        DATE 07MAR95                  */
/*                      S01343        DATE 15AUG91                  */
/*                      E22745        DATE 18JUL90                  */
/*                      E20391        DATE 26NOV89                  */
/*                      S01179        DATE 13/09/88                 */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.   */
/*                OUTQ must always be *JOBD.                        */
/*       CPK014 - Submit jobs with user *JOBD                       */
/*       S01408 - Addition of core hook SDC1760MP1                  */
/*       081177 - Use Job Description library list instead of       */
/*                current library list when submitting job.         */
/*       S01343 - SC/RR/SD MODULE RENAME PROJECT.                   */
/*                - AUTOBKP RENAMED TO RRAUTOBKP.                   */
/*       E22745 - ROUTING DATA CHANGED ON SBMJOB TO 'MBATCH' TO     *  *E22745*/
/*                STOP RRAUTOBKP FROM FALLING WHEN EM0101 RUNS, I.E.*  *E22745*/
/*                CHANGE WAIT TIME FROM 120 SECS (ON CLS QBATCH)    *  *E22745*/
/*                TO *NOMAX (ON CLS MJOBCLASS)                      *  *E22745*/
/*       E20391 - RTGDTA(*JOBD) ADDED TO ALL SBMJOB CMDS.           *  *E20391*/
/*       S01179 - AS400 CONVERSION                                  */
/*                                                                  */
/********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(8) VALUE('  XLIB  ')
             DCL        VAR(&SMSG) TYPE(*CHAR) LEN(132)
/**/
/**********  DCLDTAARA  DTAARA(SDSTAT)                              *  *S01179*/
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)             /*S01179*/
/**/
/*   GLOBAL MONITOR MESSAGE                                        */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO ABNOR)
/**/
             SNDPGMMSG  MSG('Submit Auto Backup') +
                        TOMSGQ(MRUNQ)
/**/
/*  CHECK THAT SDSTAT EXISTS                                                  */
/**/
             CHKOBJ     OBJ(SDSTAT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
               CHGVAR     VAR(&SMSG) VALUE('RRAUTOBKP not submitted +
                          - SDSTAT not found ')
               SNDMSG  MSG(&SMSG) TOMSGQ(MOPERQ)
               CHGJOB     SWS(XXXXXX11)
               GOTO       CMDLBL(ENDPGM)
             ENDDO
/**********  RCVDTAARA  DTAARA(SDSTAT)                              *  *S01179*/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)                /*S01179*/
             CHGVAR     VAR(%SUBSTRING(&LIB 1 2)) +
                          VALUE(%SUBSTRING(&SDSTAT 6 2))
 
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC1760MP1                                          */
                                                                      /*S01408*/
/**/
/*  CHECK THAT THE MJBTCH JOB DESCRIPTION EXISTS                              */
/**/
             CHKOBJ     OBJ(&LIB/MJBTCH) OBJTYPE(*JOBD)
             MONMSG     MSGID(CPF9801) EXEC(DO)
               CHGVAR     VAR(&SMSG) VALUE('RRAUTOBKP not submitted +
                          - MJBTCH job description not found ')
               SNDMSG  MSG(&SMSG) TOMSGQ(MOPERQ)
               CHGJOB     SWS(XXXXXX11)
               GOTO       CMDLBL(ENDPGM)
             ENDDO
/**/
/*       SUBMIT JOB AUTO BACKUP                                               */
/**/
/*********** SBMJOB     JOB(AUTOBKP) JOBD(&LIB/MJBTCH) JOBQ(MJBTCH) + /*E20391*/
/***********              RQSDTA('call AUTOBKP') MSGQ(MOPERQ) */
/*********** SBMJOB     JOB(AUTOBKP) JOBD(&LIB/MJBTCH) JOBQ(MJBTCH) +
/***********              RQSDTA('call AUTOBKP') MSGQ(MOPERQ) +
/***********              RTGDTA(*JOBD)                   /*E20391*/  /*E22745*/
/************SBMJOB     JOB(RRAUTOBKP) JOBD(&LIB/MJBTCH) JOBQ(MJBTCH) +
/************             RQSDTA('call RRAUTOBKP') MSGQ(MOPERQ) +
/************             RTGDTA(MBATCH)                       /*E22745 081177*/
/************SBMJOB     JOB(RRAUTOBKP) JOBD(&LIB/MJBTCH) +                                /*CPK014*/
/************             JOBQ(MJBTCH) RTGDTA(MBATCH) RQSDTA('call +                      /*CPK014*/
/************             RRAUTOBKP') INLLIBL(*JOBD) MSGQ(MOPERQ)     /*081177*/          /*CPK014*/
/************SBMJOB     JOB(RRAUTOBKP) JOBD(&LIB/MJBTCH) +                                /*CSC023*/
/************             JOBQ(MJBTCH) USER(*JOBD) RTGDTA(MBATCH) +                       /*CSC023*/
/************             RQSDTA('call RRAUTOBKP') INLLIBL(*JOBD) +                       /*CSC023*/
/************             MSGQ(MOPERQ)                                         /*CPK014*/ /*CSC023*/
             SBMJOB     JOB(RRAUTOBKP) JOBD(&LIB/MJBTCH) +
                          JOBQ(MJBTCH) USER(*JOBD) RTGDTA(MBATCH) +
                          RQSDTA('call RRAUTOBKP') INLLIBL(*JOBD) +
                          MSGQ(MOPERQ) OUTQ(*JOBD)                                        /*CSC023*/
                        GOTO ENDPGM
/**/
/*       ERROR PROCESSING                                                     */
/**/
ABNOR:       SNDPGMMSG  MSG('Submit Auto Backup +
                        ENDED ABNORMALLY') TOPGMQ(*EXT)              +
                        TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 ENDPGM:     ENDPGM
