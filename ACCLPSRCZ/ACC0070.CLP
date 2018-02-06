/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AC Autocall to beeper')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas     - System Control Module                           */
/*                                                                   */
/*       ACC0070 - Autocall Program to the Pager                     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 28Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      110242             Date 07Nov96              */
/*                      099981             DATE 23FEB96              */
/*                      098705             DATE 23JAN96              */
/*                      S01491 *CREATE     DATE 01OCT94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       110242 - Change defaults for SBMJOB cmd to take *JOBD       */
/*                also replace system JOBD of QBATCH with Midas      */
/*                JOBD of MBATCH                                     */
/*       099981 - Check all devices varied off before vary on        */
/*       098705 - If unable to allocate beeper devices, retry        */
/*                before failing - this is in the event of there     */
/*                being more than 1 system with Autocall installed.  */
/*       S01491 - Autocall.                                          */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&TEXT)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&TEXT) TYPE(*CHAR) LEN(75)
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&LOOP) TYPE(*DEC) LEN(1) VALUE(0)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&JOB1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR1) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DANAM) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SYS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&RQSDTA) TYPE(*CHAR) LEN(100) +
                          VALUE(*BLANKS)
             DCL        VAR(&FALL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(1)                 /*098705*/
/**/
             MONMSG     MSGID(CPF0000 CPA0000 CPC0000 CPD0000 +
                          RPG0000) EXEC(GOTO CMDLBL(ABNOR))
/**/
/* Create data area LDA */
/**/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
/**/
             RTVDTAARA  DTAARA(ACSTAT (51 1)) RTNVAR(&FALL)
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYS)
             CHGVAR     VAR(&DLIB) VALUE(&SYS *CAT 'DPLIB')
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&DANAM) VALUE('AC' *CAT &NBR)
             CRTDTAARA  DTAARA(&DLIB/&DANAM) TYPE(*CHAR) LEN(135) +
                          TEXT('Temporary data area for autocall +
                          primary beeper')
             CHGDTAARA  DTAARA(&DANAM (1 10)) VALUE(&JOB)
             CHGDTAARA  DTAARA(&DANAM (11 10)) VALUE(&USER)
             CHGDTAARA  DTAARA(&DANAM (21 6)) VALUE(&NBR)
             CHGDTAARA  DTAARA(&DANAM (61 75)) VALUE(&TEXT)
/************SBMJOB     CMD(CALL PGM(ACC0075) PARM(&NBR)) +           /*110242*/
/*************            JOB(#CNLJOB1) JOBQ(CNLJOBQ)     */          /*110242*/
/************SBMJOB     CMD(CALL PGM(ACC0075) PARM(&NBR)) +                               /*CPK014*/
/************             JOB(#CNLJOB1) JOBQ(CNLJOBQ) RTGDTA(*JOBD) +                     /*CPK014*/
/************             INLLIBL(*JOBD)                              /*110242*/          /*CPK014*/
/************SBMJOB     CMD(CALL PGM(ACC0075) PARM(&NBR)) +                               /*CSC023*/
/************             JOB(#CNLJOB1) JOBD(MBATCH) JOBQ(CNLJOBQ) +                      /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) INLLIBL(*JOBD)             /*CPK014*/ /*CSC023*/
             SBMJOB     CMD(CALL PGM(ACC0075) PARM(&NBR)) +
                          JOB(#CNLJOB1) JOBD(MBATCH) JOBQ(CNLJOBQ) +
                          USER(*JOBD) RTGDTA(*JOBD) INLLIBL(*JOBD) OUTQ(*JOBD)            /*CSC023*/
/**/
 LOOP:
/**/
             VRYCFG     CFGOBJ(BUBEEPL) CFGTYPE(*LIN) STATUS(*OFF)    /*099981*/
             VRYCFG     CFGOBJ(BUBEEPC) CFGTYPE(*CTL) STATUS(*OFF)    /*099981*/
             VRYCFG     CFGOBJ(BEEPERL) CFGTYPE(*LIN) STATUS(*OFF)    /*099981*/
             VRYCFG     CFGOBJ(BEEPERC) CFGTYPE(*CTL) STATUS(*OFF)    /*099981*/
             VRYCFG     CFGOBJ(BEEPERL) CFGTYPE(*LIN) STATUS(*ON)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(RETRY))       /*098705*/
             VRYCFG     CFGOBJ(BEEPERC) CFGTYPE(*CTL) STATUS(*ON)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(RETRY))       /*098705*/
                                                                      /*098705*/
             GOTO       CMDLBL(BYPASS)                                /*098705*/
                                                                      /*098705*/
RETRY:                                                                /*098705*/
             CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)                 /*098705*/
             IF         COND(&COUNT *LE 5) THEN(DO)                   /*098705*/
             DLYJOB     DLY(60)                                       /*098705*/
             GOTO       CMDLBL(LOOP)                                  /*098705*/
             ENDDO                                                    /*098705*/
             ELSE       CMD(DO)                                       /*098705*/
             GOTO       CMDLBL(ABNOR)                                 /*098705*/
             ENDDO                                                    /*098705*/
BYPASS:                                                               /*098705*/
/**/
             CLRPFM     FILE(ACTRACPD)
             TRCICF
             MONMSG     MSGID(CPF0000) EXEC(DO)
               TRCICF     SET(*OFF)
               MONMSG     MSGID(CPF0000)
               TRCICF
             ENDDO
/**/
             CALL       PGM(AC0070) PARM(&TEXT &RTNCDE)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
/**/
/** Print out ACTRACPD from call attempt                           */
/**/
             CPYF       FROMFILE(ACTRACPD) TOFILE(*PRINT) OUTFMT(*HEX)
             MONMSG     MSGID(CPF0000)
/**/
/** If call has not been accepted then try again after delay of 2  */
/** minutes                                                        */
/**/
             IF         COND((&RTNCDE *EQ 'N') *AND (&LOOP *EQ 0)) +
                          THEN(DO)
               VRYCFG     CFGOBJ(BEEPERL) CFGTYPE(*LIN) STATUS(*OFF)
               VRYCFG     CFGOBJ(BEEPERC) CFGTYPE(*CTL) STATUS(*OFF)
               DLYJOB     DLY(120)
               CHGVAR     VAR(&LOOP) VALUE(1)
               GOTO       CMDLBL(LOOP)
             ENDDO
/**/
             TRCICF     SET(*OFF)
/**/
             VRYCFG     CFGOBJ(BEEPERL) CFGTYPE(*LIN) STATUS(*OFF)
             VRYCFG     CFGOBJ(BEEPERC) CFGTYPE(*CTL) STATUS(*OFF)
/**/
/** If program completes successfully - cancel waiting job         */
/**/
             IF         COND(&RTNCDE *EQ 'Y') THEN(DO)
               RTVDTAARA  DTAARA(&DANAM (31 10)) RTNVAR(&JOB1)
               RTVDTAARA  DTAARA(&DANAM (41 10)) RTNVAR(&USER1)
               RTVDTAARA  DTAARA(&DANAM (51 6)) RTNVAR(&NBR1)
               ENDJOB     JOB(&NBR1/&USER1/&JOB1) OPTION(*IMMED)
               DLTDTAARA  DTAARA(&DANAM)
             ENDDO
/**/
             IF         COND(&RTNCDE *EQ 'N') THEN(DO)
 ABNOR:
/**/
/** If program gets this far AC0070 is not hanging - cancel        */
/** waiting job                                                    */
/**/
               RTVDTAARA  DTAARA(&DANAM (31 10)) RTNVAR(&JOB1)
               MONMSG     MSGID(CPF0000 CPA0000 CPC0000 CPD0000)
               RTVDTAARA  DTAARA(&DANAM (41 10)) RTNVAR(&USER1)
               MONMSG     MSGID(CPF0000 CPA0000 CPC0000 CPD0000)
               RTVDTAARA  DTAARA(&DANAM (51 6)) RTNVAR(&NBR1)
               MONMSG     MSGID(CPF0000 CPA0000 CPC0000 CPD0000)
               ENDJOB     JOB(&NBR1/&USER1/&JOB1) OPTION(*IMMED)
               MONMSG     MSGID(CPF0000 CPA0000 CPC0000 CPD0000)
               DLTDTAARA  DTAARA(&DANAM)
               MONMSG     MSGID(CPF0000 CPA0000 CPC0000 CPD0000)
/**/
/** If call has not been accepted after second attempt and fall-   */
/** back is required then call backup beeper                       */
/**/
               IF         COND(&FALL *EQ 'Y') THEN(DO)
                 CHGVAR     VAR(&RQSDTA) VALUE('CALL ACC0070A PARM(''' +
                              *CAT &TEXT *CAT ''')')
/**************  SBMJOB     JOB(#BACKUP) JOBD(QBATCH) JOBQ(BEEPQ) +   /*110242*/
/*************                RQSDTA(&RQSDTA)                  */     /*110242*/
/************    SBMJOB  JOB(#BACKUP) JOBD(MBATCH) JOBQ(BEEPQ) +                          /*CPK014*/
/************            RTGDTA(*JOBD) RQSDTA(&RQSDTA) INLLIBL(*JOBD) /*110242*/          /*CPK014*/
/************    SBMJOB     JOB(#BACKUP) JOBD(MBATCH) JOBQ(BEEPQ) +                       /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA(&RQSDTA) +                     /*CSC023*/
/************             INLLIBL(*JOBD)                                       /*CPK014*/ /*CSC023*/
                 SBMJOB     JOB(#BACKUP) JOBD(MBATCH) JOBQ(BEEPQ) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA(&RQSDTA) +
                          INLLIBL(*JOBD) OUTQ(*JOBD)                                      /*CSC023*/
               ENDDO
/**/
             ENDDO
/**/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
