/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TrOpics I/face - End Feeder and Trigger.')      */
/*********************************************************************/
/*                                                                   */
/*       Midas / TrOpics  Interface Enhancement.                     */
/*                                                                   */
/*       RPC5040 - Midas-TrOpics Interface - End Feeder Job and      */
/*                                         Trigger Monitor.          */
/*                                                                   */
/*       (C) COPYRIGHT Finastra International Limited 2005           */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSD026             Date 05Apr05              */
/*                      UTROPX  *CREATE    Date 21DEC01              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSD026 - Midas-TrOpics Interface upgrade to MidasPlus       */
/*       UTROPX - Midas-TrOpics Interface                            */
/*                                                                   */
/*********************************************************************/
 
             PGM
/**/
             DCL        VAR(&PRFX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RSBS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MQMSGQ) TYPE(*CHAR) LEN(48)
/*********** DCL        VAR(&INLLIBL)  TYPE(*CHAR) LEN(275)                     */        /*CSD026*/
/*********** DCL        VAR(&CMD)      TYPE(*CHAR) LEN(289)                     */        /*CSD026*/
             DCL        VAR(&INLLIBL)  TYPE(*CHAR) LEN(2750)                              /*CSD026*/
             DCL        VAR(&CMD)      TYPE(*CHAR) LEN(2764)                              /*CSD026*/
             DCL        VAR(&WAITCOUNT) TYPE(*DEC) LEN(2 0) VALUE(0)  /*CSD026*/
             DCL        VAR(&CHLNAME)  TYPE(*CHAR) LEN(50)            /*CSD026*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) +
                           Copyright Finastra International Limited +
                           2001')
/**/
/**  Global Monitor Message                                        **/
/**/
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000) EXEC(GOTO +
                          CMDLBL(TAG998))
 
             SNDPGMMSG  MSG('RPC5040 Midas-TrOpics Interface - End +
                          Feeder Job and Trigger Monitor') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
             CHGJOB     SWS(XXXXXX00)
 
/* Set TIJOBD libl */
 
             RTVJOBD    JOBD(TIJOBD) INLLIBL(&INLLIBL)
 
             CHGVAR     VAR(&CMD) VALUE('CHGLIBL LIBL(' *CAT +
                             &INLLIBL *CAT ')')
 
/************CALL       PGM(QCMDEXC) PARM(&CMD 289)                 */                    /*CSD026*/
             CALL       PGM(QCMDEXC) PARM(&CMD 2764)                                      /*CSD026*/
 
/**/
/**  End Trigger Monitor.                                          **/
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRFX)
             CHGVAR     VAR(&RSBS) VALUE('REPMIDAS' *TCAT &PRFX)
             RTVDTAARA  DTAARA(&RSBS/RPTRGMOI (1 48)) RTNVAR(&MQMSGQ)
             SNDMSGMQQ  QUEUE(&MQMSGQ) MSG('SHUTDOWN')
 
/**/
/**  End Feeder Job.                                               **/
/**/
             CALL       PGM(KMDJFC)
                                                                      /*CSD026*/
             RTVDTAARA  DTAARA(RPTROPXCHL (1 25)) RTNVAR(&CHLNAME)    /*CSD026*/
             MONMSG     MSGID(CPF1015)                                /*CSD026*/
             IF         COND(&CHLNAME *NE '         ') THEN(DO)       /*CSD026*/
             ENDMQMCHL  CHLNAME(&CHLNAME)                             /*CSD026*/
             MONMSG     MSGID(CPF0001)                                /*CSD026*/
             DLYJOB     DLY(10)                                       /*CSD026*/
             ENDDO                                                    /*CSD026*/
LON023:                                                               /*CSD026*/
                                                                      /*CSD026*/
/***  wait 15 second before ending subsystem    ***/                  /*CSD026*/
             DLYJOB     DLY(05)                                       /*CSD026*/
                                                                      /*CSD026*/
TAG001:                                                               /*CSD026*/
             ENDSBS     SBS(&RSBS) OPTION(*IMMED)                     /*CSD026*/
             MONMSG     MSGID(CPF0943)                                /*CSD026*/
             MONMSG     MSGID(CPF1056) EXEC(DLYJOB DLY(10))           /*CSD026*/
             MONMSG     MSGID(CPF1054) EXEC(GOTO CMDLBL(TAG002))      /*CSD026*/
                                                                      /*CSD026*/
/* Only wait for a maximum of 10 loops.                          **/  /*CSD026*/
                                                                      /*CSD026*/
             CHGVAR     VAR(&WAITCOUNT) VALUE(&WAITCOUNT + 1)         /*CSD026*/
             IF       COND(&WAITCOUNT > 10) THEN(GOTO CMDLBL(TAG998)) /*CSD026*/
                                                                      /*CSD026*/
             GOTO       CMDLBL(TAG001)                                /*CSD026*/
TAG002:                                                               /*CSD026*/
 
/* Set MIDASIC libl */
 
             RTVJOBD    JOBD(MIDASIC) INLLIBL(&INLLIBL)
 
             CHGVAR     VAR(&CMD) VALUE('CHGLIBL LIBL(' *CAT +
                             &INLLIBL *CAT ')')
 
/************CALL       PGM(QCMDEXC) PARM(&CMD 289)                       */              /*CSD026*/
             CALL       PGM(QCMDEXC) PARM(&CMD 2764)                                      /*CSD026*/
 
             GOTO       CMDLBL(TAG999)
 
/**/
/**  Error Processing:                                               */
/**   Dump the program if error occurred in this program             */
/**/
TAG998:      DMPCLPGM
             MONMSG     MSGID(CPF0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
             SNDMSG     MSG('Job Terminated - RPC5040 Midas-TrOpics +
                          Interface - End Feeder Job and Trigger +
                          Monitor') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000)
/**/
/**  End of Program:                                                 */
TAG999:
             ENDPGM
