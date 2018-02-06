/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AC Break handling program for ACMSGQ')          */
/*********************************************************************/
/*                                                                   */
/*       Midas     - System Control Module                           */
/*                                                                   */
/*       ACC0003 - Break handling program for error message queue    */
/*                   ACMSGQ.                                         */
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
/*                      S01491 *CREATE     DATE 01OCT94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       110242 - Change defaults for SBMJOB cmd to take *JOBD       */
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
             DCL        VAR(&RTNTYP)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&RTCD)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&FMT)     TYPE(*CHAR) LEN(200)
             DCL        VAR(&TEXT)    TYPE(*CHAR) LEN(75)
             DCL        VAR(&CUST)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&RQSDTA)  TYPE(*CHAR) LEN(100) VALUE(*BLANKS)
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
/*  Call ACC0070 to send message to the pager                      */
/**/
             CHGVAR     VAR(&TEXT) VALUE(&CUST *BCAT &MSGD)
/**/
/*/COPY ACCPYSRC,ACC0003C01                                        */
/**/
/************SBMJOB     JOB(#SNDBEEP) JOBD(MEODD) JOBQ(BEEPQ) +       /*110242*/
/*************            RQSDTA(&RQSDTA)             */              /*110242*/
/************SBMJOB     JOB(#SNDBEEP) JOBD(MEODD) JOBQ(BEEPQ) +                           /*CPK014*/
/************             RTGDTA(*JOBD) RQSDTA(&RQSDTA) +                                 /*CPK014*/
/************             INLLIBL(*JOBD)                              /*110242*/          /*CPK014*/
/************SBMJOB     JOB(#SNDBEEP) JOBD(MEODD) JOBQ(BEEPQ) +                           /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA(&RQSDTA) +                     /*CSC023*/
/************             INLLIBL(*JOBD)                                       /*CPK014*/ /*CSC023*/
             SBMJOB     JOB(#SNDBEEP) JOBD(MEODD) JOBQ(BEEPQ) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA(&RQSDTA) +
                          INLLIBL(*JOBD) OUTQ(*JOBD)                                      /*CSC023*/
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
 
             IF         COND(%SST(&FMT 20 1) *EQ 'Y') THEN(DO)
/**/
/*  Call ACC0150 to initiate ECS link                              */
/**/
               CHGVAR     VAR(&RQSDTA) VALUE('CALL ACC0150')
/************* SBMJOB     JOB(#ECSINIT) JOBD(MEODD) JOBQ(ECSJOBQ) +   /*110242*/
/*************              RQSDTA(&RQSDTA)         */                /*110242*/
/************  SBMJOB     JOB(#ECSINIT) JOBD(MEODD) JOBQ(ECSJOBQ) +                       /*CPK014*/
/************              RTGDTA(*JOBD) RQSDTA(&RQSDTA) INLLIBL(*JOBD)                   /*CPK014*/
/************                                                         /*110242*/          /*CPK014*/
/************  SBMJOB     JOB(#ECSINIT) JOBD(MEODD) JOBQ(ECSJOBQ) +                       /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA(&RQSDTA) +                     /*CSC023*/
/************             INLLIBL(*JOBD)                                       /*CPK014*/ /*CSC023*/
               SBMJOB     JOB(#ECSINIT) JOBD(MEODD) JOBQ(ECSJOBQ) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA(&RQSDTA) +
                          INLLIBL(*JOBD) OUTQ(*JOBD)                                      /*CSC023*/
             ENDDO
/**/
             CLRMSGQ    MSGQ(*LIBL/ACMSGQ)
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
             GOTO ENDPGM
/**/
/*  Error processing                                               */
/**/
 ABNOR:      SNDPGMMSG  MSG('Break handling program for error msgq  +
                          ACMSGQ ENDED ABNORMALLY') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
