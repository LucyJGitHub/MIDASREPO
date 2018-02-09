/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP Midas-Plato i/face end feeder and trigger')  */
/*********************************************************************/
/*                                                                   */
/*       Midas / Plato Interface Enhancement.                        */
/*                                                                   */
/*       RPC1040 - Midas-Plato Interface - End Feeder Job and        */
/*                                         Trigger Monitor.          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CPK014             Date 20Jun01              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CPL005             Date 23May01              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CPL003  *CREATE    Date 11Oct99              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK014 - Monitor for library already being in the libl.     */
/*       CPL005 - Add the REPMIDASxx library back into the libl      */
/*                after call to KMDJFC.                              */
/*       CPL003 - Midas-Plato Interface.                             */
/*                                                                   */
/*********************************************************************/
 
             PGM
/**/
             DCL        VAR(&MQMSGQ) TYPE(*CHAR) LEN(48)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)                                   /*CPL005*/
             DCL        VAR(&REPMIDAS) TYPE(*CHAR) LEN(10)                                /*CPL005*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/**  Global Monitor Message                                        **/
/**/
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000) EXEC(GOTO +
                          CMDLBL(TAG998))
 
             SNDPGMMSG  MSG('RPC1040 Midas-Plato Interface - End +
                          Feeder Job and Trigger Monitor') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
             CHGJOB     SWS(XXXXXX00)
/**/
/**  End Trigger Monitor.                                          **/
/**/
             RTVDTAARA  DTAARA(RPTRGMPI (1 48)) RTNVAR(&MQMSGQ)
             SNDMSGMQQ  QUEUE(&MQMSGQ) MSG('SHUTDOWN')
 
/**/                                                                                      /*CPL005*/
/**  Build the REPMIDASxx Name.                                    **/                    /*CPL005*/
/**/                                                                                      /*CPL005*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)                              /*CPL005*/
             CHGVAR     VAR(&REPMIDAS) VALUE('REPMIDAS' *CAT &PREFIX)                     /*CPL005*/
                                                                                          /*CPL005*/
/**/
/**  End Feeder Job.                                               **/
/**/
             CALL       PGM(KMDJFC)
             ADDLIBLE   LIB(&REPMIDAS) POSITION(*LAST)                                    /*CPL005*/
             MONMSG     MSGID(CPF0000)                                                    /*CPK014*/
 
             GOTO       CMDLBL(TAG999)
 
/**/
/**  Error Processing:                                               */
/**   Dump the program if error occurred in this program             */
/**/
TAG998:      DMPCLPGM
             MONMSG     MSGID(CPF0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
             SNDMSG     MSG('Job Terminated - RPC1040 Midas-Plato +
                          Interface - End Feeder Job and Trigger +
                          Monitor') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000)
/**/
/**  End of Program:                                                 */
TAG999:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
