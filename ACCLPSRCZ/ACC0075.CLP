/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AC Cancel Autocall to beeper')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas     - System Control Module                           */
/*                                                                   */
/*       ACC0075 - End Call to the Beeper                            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC023             Date 28Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CPK014             Date 14Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      110242             Date 07Nov96              */
/*                      098705             DATE 23JAN96              */
/*                      S01491 *CREATE     DATE 01OCT94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       110242 - Change defaults for SBMJOB cmd to take *JOBD       */
/*                also replace system JOBD of QBATCH with Midas      */
/*                JOBD of MBATCH                                     */
/*       098705 - Monitor for data area ACnnnnnn not existing.       */
/*       S01491 - Autocall.                                          */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&NBR)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/** Main beeper job                                                */
/**/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&FALL) TYPE(*CHAR) LEN(1)
/**/
/** Cancel job                                                     */
/**/
             DCL        VAR(&JOB1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR1) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TEXT) TYPE(*CHAR) LEN(75)
             DCL        VAR(&DANAM) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RQSDTA) TYPE(*CHAR) LEN(100) +
                          VALUE(*BLANKS)
/**/
             RTVJOBA    JOB(&JOB1) USER(&USER1) NBR(&NBR1)
             CHGVAR     VAR(&DANAM) VALUE('AC' *CAT &NBR)
             CHGDTAARA  DTAARA(&DANAM (31 10)) VALUE(&JOB1)
             MONMSG     MSGID(CPF1015) EXEC(DO)                       /*098705*/
               GOTO       CMDLBL(END)                                 /*098705*/
             ENDDO                                                    /*098705*/
             CHGDTAARA  DTAARA(&DANAM (41 10)) VALUE(&USER1)
             CHGDTAARA  DTAARA(&DANAM (51 6)) VALUE(&NBR1)
/**/
/** Wait to give ACC0070 & AC0070 a chance to run                  */
/**/
             DLYJOB     DLY(400)
 
/**/
/** If this job is still active here (ie ACC0070 has not cancelled */
/** it) there must be a problem with AC0070.  Cancel #SNDBEEP job  */
/** and resubmit it                                                */
/**/
             RTVDTAARA  DTAARA(&DANAM (1 10)) RTNVAR(&JOB)
             RTVDTAARA  DTAARA(&DANAM (11 10)) RTNVAR(&USER)
             RTVDTAARA  DTAARA(&DANAM (21 6)) RTNVAR(&NBR)
             RTVDTAARA  DTAARA(ACSTAT (51 1)) RTNVAR(&FALL)
             ENDJOB     JOB(&NBR/&USER/&JOB) OPTION(*IMMED)
             MONMSG     MSGID(CPF1362)
/**/
             DLYJOB     DLY(20)
             VRYCFG     CFGOBJ(BEEPERL) CFGTYPE(*LIN) STATUS(*OFF)
             MONMSG     MSGID(CPF0000) CMPDTA(CPD0000)
             VRYCFG     CFGOBJ(BEEPERC) CFGTYPE(*CTL) STATUS(*OFF)
             MONMSG     MSGID(CPF0000) CMPDTA(CPD0000)
/**/
             RTVDTAARA  DTAARA(&DANAM (61 75)) RTNVAR(&TEXT)
/**/
/*/COPY ACCPYSRC,ACC0075C01                                        */
/**/
             IF         COND(&JOB *NE '#RETRY    ') THEN(DO)
/************* SBMJOB     JOB(#RETRY) JOBD(QBATCH) JOBQ(BEEPQ) +      /*110242*/
/*************              RQSDTA(&RQSDTA)         */                /*110242*/
/************  SBMJOB    JOB(#RETRY) JOBD(MBATCH) JOBQ(BEEPQ) +                           /*CPK014*/
/************            RTGDTA(*JOBD) RQSDTA(&RQSDTA) INLLIBL(*JOBD) /*110242*/          /*CPK014*/
/************  SBMJOB     JOB(#RETRY) JOBD(MBATCH) JOBQ(BEEPQ) +                          /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA(&RQSDTA) +                     /*CSC023*/
/************             INLLIBL(*JOBD)                                       /*CPK014*/ /*CSC023*/
               SBMJOB     JOB(#RETRY) JOBD(MBATCH) JOBQ(BEEPQ) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA(&RQSDTA) +
                          INLLIBL(*JOBD) OUTQ(*JOBD)                                      /*CSC023*/
             ENDDO
             ELSE       CMD(DO)
/**/
/** If fallback required, submit backup job                        */
/**/
               IF         COND(&FALL *EQ 'Y') THEN(DO)
/**/
/*/COPY ACCPYSRC,ACC0075C02                                        */
/**/
/************* SBMJOB     JOB(#BACKUP) JOBD(QBATCH) JOBQ(BEEPQ) +     /*110242*/
/*************              RQSDTA(&RQSDTA)              */           /*110242*/
/************  SBMJOB     JOB(#BACKUP) JOBD(MBATCH) JOBQ(BEEPQ) +                         /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA(&RQSDTA) +                     /*CSC023*/
/************             INLLIBL(*JOBD)                                       /*CPK014*/ /*CSC023*/
               SBMJOB     JOB(#BACKUP) JOBD(MBATCH) JOBQ(BEEPQ) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA(&RQSDTA) +
                          INLLIBL(*JOBD) OUTQ(*JOBD)                                      /*CSC023*/
               ENDDO
/**/
             ENDDO
/**/
             DLTDTAARA  DTAARA(&DANAM)
             MONMSG     MSGID(CPF0000)                                /*098705*/
/**/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
