/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AC Initiate ECS Link')                          */
/*********************************************************************/
/*                                                                   */
/*       Midas     - System Control Module                           */
/*                                                                   */
/*       ACC0150 - Initiate ECS Link                                 */
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
/*                      101930             DATE 08JUL96              */
/*                      098705             DATE 05FEB96              */
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
/*       101930 - Improve monitoring of messages to aid debug of     */
/*                Autocall programs should they cause any problems.  */
/*              - Monitor also for CPI0000 and CPA0000 to check      */
/*                if vary commands incomplete, line busy or          */
/*                failure to call controller.                        */
/*              - the number of ECS lines is 9, not 5.               */
/*       098705 - Monitor for 'Vary command may not have completed'  */
/*       S01491 - Autocall.                                          */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/** Initial processing                                             */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&LINSTAT) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&LINSTAS) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&LIN) TYPE(*CHAR) LEN(8)
             DCL        VAR(&CTL) TYPE(*CHAR) LEN(8)
             DCL        VAR(&DEV) TYPE(*CHAR) LEN(9)
             DCL        VAR(&REM) TYPE(*CHAR) LEN(4)
             DCL        VAR(&USRID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PASS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NUM) TYPE(*DEC) LEN(1 0)
             DCL        VAR(&RQSDTA) TYPE(*CHAR) LEN(100) VALUE(*BLANK)
             DCL        VAR(&TEXT) TYPE(*CHAR) LEN(75) VALUE(*BLANK)
             DCL        VAR(&CUST) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NO) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FAIL) TYPE(*CHAR) LEN(4)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(1) VALUE(1)        /*098705*/
 
/**/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ABNOR))
/**                                                                   /*101930*/
/** Set logging level to maximum **/                                  /*101930*/
/**                                                                   /*101930*/
             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)               /*101930*/
/**/
             ADDLIBLE   LIB(ECSLIB)
             MONMSG     MSGID(CPF2103)
/**/
/** Start default subsystems if not already active                 */
/**/
             STRSBS     SBSD(ECSSBS)
             MONMSG     MSGID(CPF1010) EXEC(GOTO CMDLBL(MISS1))
             DLYJOB     DLY(30)
/**/
 MISS1:      STRSBS     SBSD(QINTER)
             MONMSG     MSGID(CPF1010) EXEC(GOTO CMDLBL(MISS2))
             DLYJOB     DLY(30)
/**/
/** Retrieve customer ID, ECS user ID and password                 */
/**/
 MISS2:      RTVDTAARA  DTAARA(ACSTAT (41 10)) RTNVAR(&CUST)
             RTVDTAARA  DTAARA(ACSTAT (21 10)) RTNVAR(&USRID)
             RTVDTAARA  DTAARA(ACSTAT (31 10)) RTNVAR(&PASS)
/**/
/** Check that LIN011 resource is not already in use               */
/**/
             RTVCFGSTS  CFGD(QESLINE) CFGTYPE(*LIN) STSCDE(&LINSTAT)
             RTVCFGSTS  CFGD(QTILINE) CFGTYPE(*LIN) STSCDE(&LINSTAS)
/**/
             IF         COND((&LINSTAT *EQ 60) *OR (&LINSTAS *EQ +
                          60)) THEN(DO)
               CHGVAR     VAR(&TEXT) VALUE(&CUST *CAT 'Dial IBM is +
                            currently in use.')
               GOTO       CMDLBL(SNDERR)
             ENDDO
/**/
             IF         COND(&LINSTAT *EQ 40) THEN(DO)
               VRYCFG     CFGOBJ(QESLINE) CFGTYPE(*LIN) STATUS(*OFF)
               MONMSG     MSGID(CPF0000)
             ENDDO
/**/
             IF         COND(&LINSTAS *EQ 40) THEN(DO)
               VRYCFG     CFGOBJ(QTILINE) CFGTYPE(*LIN) STATUS(*OFF)
               MONMSG     MSGID(CPF0000)
             ENDDO
/**/
/** Attempt to start APPC link to allow ECS to be started.         */
/** Do this by trying each line in succession until one is         */
/** available.                                                     */
/**/
             CHGVAR     VAR(&NUM) VALUE(1)
 LOOP:
             CHGVAR     VAR(&NO) VALUE(&NUM)
             CHGVAR     VAR(&LIN) VALUE('ECSLIN0' *TCAT &NO)
             CHGVAR     VAR(&CTL) VALUE('ECSCTL0' *TCAT &NO)
             CHGVAR     VAR(&DEV) VALUE('VIRTDEV0' *TCAT &NO)
             CHGVAR     VAR(&REM) VALUE('REM' *TCAT &NO)
/**/
             VRYCFG     CFGOBJ(&LIN) CFGTYPE(*LIN) STATUS(*OFF)
/************MONMSG*****MSGID(CPF0000)******************************/ /*101930*/
             MONMSG     MSGID(CPF0000 CPI0000 CPA0000)                /*101930*/
             DLYJOB     DLY(15)                                       /*098705*/
/**/
/*  Vary on ECS line and controller                                    *098705*/
/*  Monitor for 'Vary command may not have completed'                  *098705*/
VARY_ON:                                                              /*098705*/
             VRYCFG     CFGOBJ(&LIN) CFGTYPE(*LIN) STATUS(*ON)
/************MONMSG*****MSGID(CPF2659) EXEC(DO)**********/ /*098705*/ /*101930*/
             MONMSG     MSGID(CPF0000 CPI0000 CPA0000) EXEC(DO)       /*101930*/
               IF         COND(&COUNT *LE 5) THEN(DO)                 /*098705*/
                 DLYJOB     DLY(30)                                   /*098705*/
                 CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)             /*098705*/
                 GOTO       CMDLBL(VARY_ON)                           /*098705*/
                 ENDDO                                                /*098705*/
                 ELSE       CMD(DO)                                   /*098705*/
                 CHGVAR     VAR(&NUM) VALUE(&NUM + 1)                 /*098705*/
                 GOTO       CMDLBL(LOOP)                              /*098705*/
               ENDDO                                                  /*098705*/
             ENDDO                                                    /*098705*/
             VRYCFG     CFGOBJ(&CTL) CFGTYPE(*CTL) STATUS(*ON)
/************MONMSG*****MSGID(CPF0000)******************************/ /*101930*/
             MONMSG     MSGID(CPF0000 CPI0000 CPA0000)                /*101930*/
/**/
             DLYJOB     DLY(5)
/**/
/** Setup communications file for the correct location.            */
/** Call program to initiate COMMS                                 */
/**/
             OVRICFF    FILE(AC4000CM) ACQPGMDEV(PGMDEV1)
             CHGVAR     VAR(&FAIL) VALUE('OPEN')
             CALL       PGM(AC4000) PARM(&USRID &PASS &NO &FAIL)
             CLOF       OPNID(AC4000CM)
             MONMSG     MSGID(CPF0000 CPI0000 CPA0000)                /*101930*/
             RCLRSC                                                   /*101930*/
             MONMSG     CPF4520
             RCLRSC
             DLTOVR     FILE(AC4000CM)
/**/
/** If call to AC4000 fails, then this line is used at ACT,        */
/** try again                                                      */
/**/
             IF COND(&FAIL *EQ 'OPEN') THEN(DO)
               VRYCFG     CFGOBJ(&LIN) CFGTYPE(*LIN) STATUS(*OFF)
               MONMSG     MSGID(CPF0000 CPI0000 CPA0000)              /*101930*/
               VRYCFG     CFGOBJ(&CTL) CFGTYPE(*CTL) STATUS(*OFF)
               MONMSG     MSGID(CPF0000 CPI0000 CPA0000)              /*101930*/
/**/
/**************IF         COND(&NUM *EQ 5) THEN(GOTO CMDLBL(UNABL))*/ /*101930*/
               IF         COND(&NUM *EQ 9) THEN(GOTO CMDLBL(UNABL))   /*101930*/
/**/
               CHGVAR     VAR(&NUM) VALUE(&NUM + 1)
               GOTO       CMDLBL(LOOP)
/**/
 UNABL:        CHGVAR     VAR(&TEXT) VALUE(&CUST *CAT ' Unable to +
                            start ECS')
               GOTO       CMDLBL(SNDERR)
             ENDDO
/**/
/** Otherwise, program ran ok, and ECS has been used, so just vary */
/** off this line and end                                          */
/**/
             VRYCFG     CFGOBJ(&LIN) CFGTYPE(*LIN) STATUS(*OFF)
             VRYCFG     CFGOBJ(&CTL) CFGTYPE(*CTL) STATUS(*OFF)
             GOTO       CMDLBL(END)
/**/
 SNDERR:
/**/
/*/COPY ACCPYSRC,ACC0150C01                                        */
/**/
/************SBMJOB     JOB(#SNDBEEP) JOBD(QBATCH) JOBQ(BEEPQ) +      /*110242*/
/*************            RQSDTA(&RQSDTA)                 */          /*110242*/
/************SBMJOB     JOB(#SNDBEEP) JOBD(MBATCH) JOBQ(BEEPQ) +                          /*CPK014*/
/************           RTGDTA(*JOBD) RQSDTA(&RQSDTA) INLLIBL(*JOBD)  /*110242*/          /*CPK014*/
/************SBMJOB     JOB(#SNDBEEP) JOBD(MBATCH) JOBQ(BEEPQ) +                          /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA(&RQSDTA) +                     /*CSC023*/
/************             INLLIBL(*JOBD)                                       /*CPK014*/ /*CSC023*/
             SBMJOB     JOB(#SNDBEEP) JOBD(MBATCH) JOBQ(BEEPQ) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA(&RQSDTA) +
                          INLLIBL(*JOBD) OUTQ(*JOBD)                                      /*CSC023*/
/**/
 ABNOR:      SNDPGMMSG  MSG('Initiate ECS Link ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
