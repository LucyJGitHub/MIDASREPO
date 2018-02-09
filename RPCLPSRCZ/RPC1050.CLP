/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP End of download processing')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas / Plato Interface Enhancement.                        */
/*                                                                   */
/*       RPC1050 - Midas-Plato Interface - End of Download Processing*/
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Prev Amend No. 177415  *CREATE    Date 06Apr00              */
/*                      CPL003  *CREATE    Date 06Apr00              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       177415 - Replication performance improvements.              */
/*       CPL003 - Midas-Plato Interface.                             */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&MQOUTQ &MQHEAD &MQDATA &MQCMMT &MQRTCD)
/**/
             DCL        VAR(&MQOUTQ) TYPE(*CHAR) LEN(48)
             DCL        VAR(&MQHEAD) TYPE(*CHAR) LEN(138)
             DCL        VAR(&MQDATA) TYPE(*CHAR) LEN(5000)
             DCL        VAR(&MQCMMT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MQRTCD) TYPE(*CHAR) LEN(10)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/**  Global Monitor Message                                        **/
/**/
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000) EXEC(GOTO +
                          CMDLBL(TAG998))
 
             SNDPGMMSG  MSG('RPC1050 Midas-Plato Interface - End of +
                          Download Processing') TOMSGQ(MRUNQ) +
                          MSGTYPE(*INFO)
/**/
/**  Close down the Feeder job and Trigger Processor.             **/
/**/
             CALL       PGM(RPC1040)
/**/
/**  Send Message to inform of end of download.                   **/
/**/
             SNDPGMMSG  MSG('The Midas-Plato Interface Replication +
                          download has completed.') TOMSGQ(MOPERQ +
                          MRUNQ) MSGTYPE(*INFO)
 
             GOTO       CMDLBL(TAG999)
 
/**/
/**  Error Processing:                                               */
/**   Dump the program if error occurred in this program             */
/**/
TAG998:      DMPCLPGM
             CHGVAR     VAR(&MQRTCD) VALUE('ErrRPC1050')
             MONMSG     MSGID(CPF0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
             SNDMSG     MSG('Job Terminated - RPC1050 Midas-Plato +
                          Interface - End of Download Processing') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000)
/**/
/**  End of Program:                                                 */
TAG999:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
