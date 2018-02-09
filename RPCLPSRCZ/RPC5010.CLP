/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TrOpics I/face - start trigger monitor')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Replication                                         */
/*                                                                   */
/*       RPC5010 - Midas-TrOpics Interface - Start Trigger Monitor.  */
/*                                                                   */
/*       (C) COPYRIGHT Finastra International Limited 2005           */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 240075             Date 30Jun06              */
/*                      CSD026             Date 05Apr05              */
/*                      UTROPX  *Create    Date 11Dec01              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       240075 - Submit job under xxOWNER not the signed on user.   */
/*       CSD026 - Midas-TrOpics Interface upgrade to MidasPlus       */
/*       UTROPX - Midas-TROpics Interface.                           */
/*                                                                   */
/*********************************************************************/
 
             PGM
 
             DCL        VAR(&DTAAREALIB) TYPE(*CHAR) LEN(10) +
                 /* Library containing the data area to retrieve   */
             DCL        VAR(&DTAAREA) TYPE(*CHAR) LEN(10) +
                 /* Data area to retrieve   */
 
             DCL        VAR(&INITQUEUE) TYPE(*CHAR) LEN(48) +
                 /* MQSeries initiation queue that is to be read   */
             DCL        VAR(&COMMITCTL) TYPE(*CHAR) LEN(1) +
                 /* Flag saying whether commitment control is used   */
 
             DCL        VAR(&JOBNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WAITCOUNT) TYPE(*DEC) LEN(2 0) VALUE(0)
             DCL        VAR(&PRFX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RSBS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&INLLIBL)  TYPE(*CHAR) LEN(2750)         /*CSD026*/
/*******     DCL        VAR(&INLLIBL)  TYPE(*CHAR) LEN(275)   *****/ /*CSD026*/
/*******     DCL        VAR(&CMD)      TYPE(*CHAR) LEN(289)   *****/ /*CSD026*/
             DCL        VAR(&CMD)      TYPE(*CHAR) LEN(2764)         /*CSD026*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) +
                           Copyright Finastra International Limited +
                           2001')
 
/**  Global Monitor Message                                        **/
 
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000) EXEC(GOTO +
                          CMDLBL(TAG998))
 
             SNDPGMMSG  MSG('RPC5010 Midas-TrOpics Interface - Start +
                          Trigger Monitor') TOMSGQ(MRUNQ) +
                          MSGTYPE(*INFO)
             CHGJOB     SWS(XXXXXX00)
 
/* Set TIJOBD libl */
 
             RTVJOBD    JOBD(TIJOBD) INLLIBL(&INLLIBL)
 
             CHGVAR     VAR(&CMD) VALUE('CHGLIBL LIBL(' *CAT +
                             &INLLIBL *CAT ')')
 
/***         CALL       PGM(QCMDEXC) PARM(&CMD 289)            ***/     /*CSD026*/
             CALL       PGM(QCMDEXC) PARM(&CMD 2764)                    /*CSD026*/
 
 
/*  Get Midas system prefix and construct the name of the         **/
/*    Replication sub-system.                                     **/
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRFX)
             CHGVAR     VAR(&RSBS) VALUE('REPMIDAS' *TCAT &PRFX)
 
/* Start the Replication Trigger Monitor.                        **/
 
 
/* Set up parameters to Trigger Monitor Server                */
             CHGVAR     VAR(&DTAAREALIB) VALUE(&RSBS)
             CHGVAR     VAR(&DTAAREA)    VALUE('RPTRGMOI  ')
 
/* Set up input values to Trigger Monitor Server                */
             CHGVAR     VAR(&INITQUEUE) +
                          VALUE('REPN.INITIATION.QUEUE.FROM.MIDAS' +
                          *CAT &PRFX)
             CHGVAR     VAR(&COMMITCTL) VALUE('Y')
 
/* Store input values to Trigger Monitor Server                */
             CHKOBJ     OBJ(&DTAAREALIB/&DTAAREA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                CRTDTAARA  DTAARA(&DTAAREALIB/&DTAAREA) TYPE(*CHAR) +
                             LEN(256)
             ENDDO
 
             CHGDTAARA  DTAARA(&DTAAREALIB/&DTAAREA (1 48)) +
                          VALUE(&INITQUEUE)
             CHGDTAARA  DTAARA(&DTAAREALIB/&DTAAREA (49 1)) +
                          VALUE(&COMMITCTL)
 
/* Set up parameters to SBMJOB command                             */
             CHGVAR     VAR(&JOBNAME) VALUE('RPTRGMOI  ')
 
/* Submit the Trigger Monitor Server                               */
/**********  SBMJOB     CMD(CALL PGM(RPTRGMON) PARM(&DTAAREALIB +
                          &DTAAREA)) JOB(&JOBNAME) JOBD(TIJOBD) +
                          JOBQ(&RSBS/&RSBS) INLLIBL(*JOBD)                                /*240075*/
             SBMJOB     CMD(CALL PGM(RPTRGMON) PARM(&DTAAREALIB +
                          &DTAAREA)) JOB(&JOBNAME) JOBD(TIJOBD) +
                          JOBQ(&RSBS/&RSBS) USER(*JOBD) +
                          INLLIBL(*JOBD)                                                  /*240075*/
 
/* Set MIDASIC libl */
 
             RTVJOBD    JOBD(MIDASIC) INLLIBL(&INLLIBL)
 
             CHGVAR     VAR(&CMD) VALUE('CHGLIBL LIBL(' *CAT +
                             &INLLIBL *CAT ')')
 
/*           CALL       PGM(QCMDEXC) PARM(&CMD 289)                */ /*CSD026*/
             CALL       PGM(QCMDEXC) PARM(&CMD 2764)                  /*CSD026*/
 
             GOTO       CMDLBL(TAG999)
 
/* Error Processing:                                               */
/* Dump the program if error occurred in this program              */
 
TAG998:
             DMPCLPGM
             MONMSG     MSGID(CPF0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
             SNDMSG     MSG('Job terminated - RPC5010 Midas-TrOpics +
                          Interface - Start Trigger Monitor - Ended +
                          in Error') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000)
 
/* End of Program:                                                 */
TAG999:
             ENDPGM
