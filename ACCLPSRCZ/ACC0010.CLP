/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AC Error Handling Program for QSYSOPR')         */
/*********************************************************************/
/*                                                                   */
/*       Midas     - System Control Module                           */
/*                                                                   */
/*       ACC0010 - QSYSOPR message queue monitoring program          */
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
/*                      110242             DATE 07NOV96              */
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
/*       S01491 - Autocall.                                          */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&MSGQ &MSGQLIB &MSGKEY)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&MSGQ)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGQLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGKEY)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&MSGID)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGD)    TYPE(*CHAR) LEN(200)
             DCL        VAR(&SENDER)  TYPE(*CHAR) LEN(80)
             DCL        VAR(&SNDJOB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SNDUSR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SNDNBR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SNDPGM)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SNDDAT)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&SNDTIM)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&DFTRPY)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTNTYP)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&ALERT)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&TEXT)    TYPE(*CHAR) LEN(75)
             DCL        VAR(&CUST)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&RQSDTA)  TYPE(*CHAR) LEN(100) VALUE(*BLANKS)
             DCL        VAR(&RTCD)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&FMT)     TYPE(*CHAR) LEN(200)
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO ABNOR)
/**/
/*  Retrieve Customers id                                          */
/**/
             RTVDTAARA  DTAARA(ACSTAT (41 10)) RTNVAR(&CUST)
/**/
/*  Retrieve message arrived in the message queue                  */
/**/
             RCVMSG     MSGQ(&MSGQLIB/&MSGQ) MSGKEY(&MSGKEY) +
                        RMV(*NO) MSG(&MSGD) MSGID(&MSGID) +
                        SENDER(&SENDER) RTNTYPE(&RTNTYP)
/**/
/*  Select only Inquiry and Notify messages                        */
/**/
             IF         COND((&RTNTYP *NE '05') *AND (&RTNTYP *NE '14')) +
                          THEN(GOTO ENDPGM)
/**/
/* Check if message indicates that the ECS line is busy            */
/**/
             IF         COND((&MSGID *EQ 'CPA58D9') *OR (&MSGID *EQ +
                          'CPA58D6')) THEN(DO)
             CHGVAR     VAR(&DFTRPY) VALUE('C')
             GOTO       CMDLBL(REPLY)
             ENDDO
/**/
/*  Retrieve the sending program of this message                   */
/**/
             CHGVAR     VAR(&SNDJOB) VALUE(%SST(&SENDER  1 10))
             CHGVAR     VAR(&SNDUSR) VALUE(%SST(&SENDER 11 10))
             CHGVAR     VAR(&SNDNBR) VALUE(%SST(&SENDER 21  6))
             CHGVAR     VAR(&SNDPGM) VALUE(%SST(&SENDER 27 10))
             CHGVAR     VAR(&SNDDAT) VALUE(%SST(&SENDER 44  6))
             CHGVAR     VAR(&SNDTIM) VALUE(%SST(&SENDER 50  6))
/**/
/*  Verify automatic answer file                                   */
/**/
             CALL       PGM(AC0020) PARM(&MSGID  &SNDJOB &SNDUSR &SNDNBR +
                          &SNDPGM &SNDDAT &SNDTIM &DFTRPY &ALERT)
/**/
/*  If this is from init ECS link or pager then do not send msg as */
/*  it could get into loop so just send default reply              */
/**/
             IF         COND((&SNDJOB *EQ '#ECSINIT') *OR (&SNDJOB +
                          *EQ '#SNDBEEP')) THEN(GOTO CMDLBL(REPLY))
/**/
             IF         COND(&ALERT *EQ 'Y') THEN(DO)
/**/
               CHGVAR     VAR(&TEXT) VALUE(&CUST *BCAT &MSGD)
/**/
/*/COPY ACCPYSRC,ACC0010C01                                        */
/**/
/************* SBMJOB       JOB(#SNDBEEP) JOBD(QBATCH) JOBQ(BEEPQ) +  /*110242*/
/*************                RQSDTA(&RQSDTA)             */          /*110242*/
/************  SBMJOB    JOB(#SNDBEEP) JOBD(MBATCH) JOBQ(BEEPQ) +                         /*CPK014*/
/************            RTGDTA(*JOBD) RQSDTA(&RQSDTA) INLLIBL(*JOBD) /*110242*/          /*CPK014*/
/************  SBMJOB     JOB(#SNDBEEP) JOBD(MBATCH) JOBQ(BEEPQ) +                        /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA(&RQSDTA) +                     /*CSC023*/
/************             INLLIBL(*JOBD)                                       /*CPK014*/ /*CSC023*/
               SBMJOB     JOB(#SNDBEEP) JOBD(MBATCH) JOBQ(BEEPQ) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA(&RQSDTA) +
                          INLLIBL(*JOBD) OUTQ(*JOBD)                                     /*CSC0233*/
/**/
/*  Call COB ICD to check for Initiate ECS Flag                    */
/**/
               CHGVAR     VAR(&RTCD) VALUE('       ')
               CHGVAR     VAR(&OPTN) VALUE('*FIRST')
/**/
               CALL       PGM(AOCOBPR0) PARM(&RTCD &OPTN &FMT)
/**/
               IF         COND(&RTCD *NE '       ') THEN(DO)
                 SNDPGMMSG  MSG('Error on access to ICD file +
                              SDCOBPPD') TOMSGQ(MOPERQ)
                 GOTO       CMDLBL(ABNOR)
               ENDDO
/**/
               IF         COND(%SST(&FMT 20 1) *EQ 'Y') THEN(DO)
/**/
                 CHGVAR     VAR(&RQSDTA) VALUE('CALL ACC0150')
/**************  SBMJOB     JOB(#ECSINIT) JOBD(QBATCH) JOBQ(ECSJOBQ) +/*110242*/
/*************                RQSDTA(&RQSDTA)             */          /*110242*/
/************    SBMJOB  JOB(#ECSINIT) JOBD(MBATCH) JOBQ(ECSJOBQ) +                       /*CPK014*/
/************            RTGDTA(*JOBD) RQSDTA(&RQSDTA) INLLIBL(*JOBD) /*110242*/          /*CPK014*/
/************    SBMJOB     JOB(#ECSINIT) JOBD(MBATCH) JOBQ(ECSJOBQ) +                    /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA(&RQSDTA) +                     /*CSC023*/
/************             INLLIBL(*JOBD)                                       /*CPK014*/ /*CSC023*/
                 SBMJOB     JOB(#ECSINIT) JOBD(MBATCH) JOBQ(ECSJOBQ) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA(&RQSDTA) +
                          INLLIBL(*JOBD) OUTQ(*JOBD)                                      /*CSC023*/
/**/
               ENDDO
/**/
             ENDDO
/**/
 REPLY:
             IF         COND(&DFTRPY *NE ' ') THEN(DO)
               SNDRPY MSGKEY(&MSGKEY) MSGQ(&MSGQLIB/&MSGQ) RPY(&DFTRPY)
               MONMSG     MSGID(CPF2420)
             ENDDO
             GOTO       CMDLBL(ENDPGM)
/**/
/*  Error processing                                               */
/**/
 ABNOR:      SNDPGMMSG  MSG('Break handling program for msgq  +
                          QSYSOPR ENDED ABNORMALLY') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
