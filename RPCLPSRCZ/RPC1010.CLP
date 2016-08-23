/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP Plato interface - start trigger monitor')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Replication                                         */
/*                                                                   */
/*       RPC1010 - Midas-Plato Interface - Start Trigger Monitor.    */
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
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      173248             Date 06Jan00              */
/*                      CPL003  *CREATE    Date 11Oct99              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       173248 - Change REPMIDAS subsystem amended to include       */
/*                the Midas System Prefix.                           */
/*       CPL003 - Midas-Plato Interface.                             */
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
             DCL        VAR(&PRFX) TYPE(*CHAR) LEN(2)                                     /*173248*/
             DCL        VAR(&RSBS) TYPE(*CHAR) LEN(10)                                    /*173248*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/**  Global Monitor Message                                        **/
 
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000) EXEC(GOTO +
                          CMDLBL(TAG998))
 
             SNDPGMMSG  MSG('RPC1010 Midas-Plato Interface - Start +
                          Trigger Monitor') TOMSGQ(MRUNQ) +
                          MSGTYPE(*INFO)
             CHGJOB     SWS(XXXXXX00)
 
/*  Get Midas system prefix and construct the name of the         **/         /*173248*/
/*    Replication sub-system.                                     **/         /*173248*/
                                                                              /*173248*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRFX)                    /*173248*/
             CHGVAR     VAR(&RSBS) VALUE('REPMIDAS' *TCAT &PRFX)              /*173248*/
                                                                              /*173248*/
/* Start the Replication Trigger Monitor.                        **/
 
 
/* Set up parameters to Trigger Monitor Server                */
/**********  CHGVAR     VAR(&DTAAREALIB) VALUE('REPMIDAS  ')                              /*173248*/
             CHGVAR     VAR(&DTAAREALIB) VALUE(&RSBS)                                     /*173248*/
             CHGVAR     VAR(&DTAAREA)    VALUE('RPTRGMPI  ')
 
/* Set up input values to Trigger Monitor Server                */
/**********  CHGVAR     VAR(&INITQUEUE) +                           */                    /*173248*/
/**********               VALUE('REPN.INITIATION.QUEUE.FROM.MIDAS') */                    /*173248*/
             CHGVAR     VAR(&INITQUEUE) +
                          VALUE('REPN.INITIATION.QUEUE.FROM.MIDAS' +
                          *CAT &PRFX)                                                     /*173248*/
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
             CHGVAR     VAR(&JOBNAME) VALUE('RPTRGMPI  ')
 
/* Submit the Trigger Monitor Server                               */
/**********  SBMJOB     CMD(CALL PGM(RPTRGMON) PARM(&DTAAREALIB + */                      /*173248*/
/**********               &DTAAREA)) JOB(&JOBNAME) JOBD(TIJOBD)   */                      /*173248*/
/************SBMJOB     CMD(CALL PGM(RPTRGMON) PARM(&DTAAREALIB +                         /*CPK014*/
/************             &DTAAREA)) JOB(&JOBNAME) JOBD(TIJOBD) +                         /*CPK014*/
/************             INLLIBL(*JOBD)                                      /*173248*/ /* CPK014*/
/************SBMJOB     CMD(CALL PGM(RPTRGMON) PARM(&DTAAREALIB +                         /*CSC023*/
/************             &DTAAREA)) JOB(&JOBNAME) JOBD(TIJOBD) +                         /*CSC023*/
/************             USER(*JOBD) INLLIBL(*JOBD)                           /*CPK014*/ /*CSC023*/
             SBMJOB     CMD(CALL PGM(RPTRGMON) PARM(&DTAAREALIB +
                          &DTAAREA)) JOB(&JOBNAME) JOBD(TIJOBD) +
                          USER(*JOBD) INLLIBL(*JOBD) OUTQ(*JOBD)                          /*CSC023*/
 
             GOTO       CMDLBL(TAG999)
 
/* Error Processing:                                               */
/* Dump the program if error occurred in this program              */
 
TAG998:
             DMPCLPGM
             MONMSG     MSGID(CPF0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
             SNDMSG     MSG('Job terminated - RPC1010 Midas-Plato +
                          Interface - Start Trigger Monitor - Ended +
                          in Error') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000)
 
/* End of Program:                                                 */
TAG999:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
