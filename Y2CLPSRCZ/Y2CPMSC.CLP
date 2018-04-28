/*********************************************************************/
/*                                                                   */
/*       Midas - (Module Name) Module                                */
/*                                                                   */
/*       mmCnnnn - (Program Name)                                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Last Amend No. Xnnnnn  *CREATE    Date ddmmmyy              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       Xnnnnn - (fix description)                                  */
/*                                                                   */
/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Y2 R2.1.1 Copy nominated pgm msg queue to previous')  */
/*********************************************************************/
/*T: YAPPOBJ Copy nominated pgm msg queue to previous. */
/*Z: CRTCLPGM LOG(*NO)  */
/*H: SYSTEM     : SYNON/2 - SHIPPED PROGRAM.                           */
/*H: PROGRAMMER : J.P.Lodge                                            */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*       (c) Misys International Banking Systems Ltd. 2001           */
 
/*H:  SYNOPSIS:  Copies a specified program message queue to                 */
/*H:             the previous program's message queue.                       */
 
/*H:  INTERFACE DETAILS ;                                                    */
/*H:  *..................................................................... */
/*H:  *  Copy messages back to Previous program                              */
/*H: C                     CALL 'Y2CPMSC'                  Copy back messages*/
/*H: C                     PARM           ##PGM  10        I: Program name   */
/*H:  *..................................................................... */
/********************************************************************/
PGM   (&PGMQ)
 
DCL &PGMQ     *CHAR 10    /* Program message queue name             */
DCL &MSGDTA   *CHAR 132   /* Message data                           */
DCL &MSGID    *CHAR 7     /* Message ID                             */
DCL &RTNTYPE  *CHAR 2     /* Message type (coded)                   */
DCL &MSGF     *CHAR 10    /* Message file                           */
DCL &MSGFLIB  *CHAR 10    /* Message file library                   */
DCL &MSGTYPE  *CHAR 7     /* Message type (plain)                   */
DCL &ESCAPE   *CHAR 7     /* Translate *ESCAPE messages into :- ??? */
DCL &NOTIFY   *CHAR 7     /* Translate *NOTIFY messages into :- ??? */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/*==================================================================*/
             MONMSG     MSGID(CPF0000) EXEC(GOTO ENDPGM)
/*==================================================================*/
 
/*H: 0.  Translate *ESCAPE and *NOTIFY into *DIAG messages */
             CHGVAR     &ESCAPE *DIAG
             CHGVAR     &NOTIFY *DIAG
 
 LOOP:
/*H: 1.  Receive a message from nominated message queue */
             RCVMSG     PGMQ(*SAME &PGMQ) MSGTYPE(*ANY) RMV(*YES) +
                          MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          RTNTYPE(&RTNTYPE) MSGF(&MSGF) +
                          MSGFLIB(&MSGFLIB)
 
/*H: 1.1 No message received? - skip out */
             IF         (&MSGID *EQ ' ') +
             THEN(       GOTO ENDPGM)
 
/*H: 2   Translate coded message type to plain text */
             CHGVAR     &MSGTYPE ' '
             IF         (&RTNTYPE *EQ '01') +
             THEN(       CHGVAR  &MSGTYPE  *COMP)
             IF         (&RTNTYPE *EQ '02') +
             THEN(       CHGVAR  &MSGTYPE  *DIAG)
             IF         (&RTNTYPE *EQ '04') +
             THEN(       CHGVAR  &MSGTYPE  *INFO)
             IF         (&RTNTYPE *EQ '14') +
             THEN(       CHGVAR  &MSGTYPE  &NOTIFY)
             IF         (&RTNTYPE *EQ '15') +
             THEN(       CHGVAR  &MSGTYPE  &ESCAPE)
 
/*H: 2.1 If message type is untranslatable, dont copy it */
             IF         (&MSGTYPE *EQ ' ') +
             THEN(       GOTO LOOP)
 
/*H: 3.  Copy the message to previos program message queue */
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
MSGDTA(&MSGDTA) TOPGMQ(*PRV &PGMQ) MSGTYPE(&MSGTYPE)
 
/*H: 4.  Retry for more messages */
             GOTO LOOP
 ENDPGM:
             RETURN
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
ENDPGM
