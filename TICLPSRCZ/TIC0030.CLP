/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TI Stop/start SD replication in TI/CSCS')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Trade Innovation Module                             */
/*                                                                   */
/*       TIC0030 - TI Stop/Start SD Replication in TI/CSCS           */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       This component controls the continuous download SD on-line  */
/*       download to TI by sending a message to th TI/CSCS to inform */
/*       it when to stop and when to start the standing data         */
/*       replication task job.                                       */
/*                                                                   */
/*       The SD replication task job must be stopped and started:    */
/*       i)  When journal entries are changed;                       */
/*       ii) During COB-from IC Termination to just before IC Init.; */
/*       iii)When a Midas IC database save or restore is being done. */
/*                                                                   */
/*       Two messages may be sent: 'STOP' and 'START'.               */
/*       For the stop message alone, a reply is expected from the    */
/*       TI/CSCS confirming that the SD replicator is stopped.       */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CTI001  *CREATE    Date 28Jul97              */
/*            Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CTI001 - Midas / Trade Innovation Interface Phase 1         */
/*                Program created.                                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MESGS &CALLER)
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MESGS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CALLER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SEND) TYPE(*CHAR) LEN(80)
             DCL        VAR(&LENGTH) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&RESPONSE) TYPE(*CHAR) LEN(80)
             DCL        VAR(&FIRSTRUN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
             RTVJOBA    TYPE(&JOBTYPE)
 
             SNDPGMMSG  MSG('TIC0030 - Stop & Start the SD +
                          Replication Task in the TI/CSCS') +
                          TOMSGQ(MRUNQ)
 
/* If this is the first time the TI module is installed don't */
/* start replication job  */
             RTVDTAARA  DTAARA(TIDTA (31 1)) RTNVAR(&FIRSTRUN)
             IF         COND(&MESGS *EQ 'START     ' *AND &FIRSTRUN +
                          *EQ 'Y') THEN(GOTO CMDLBL(END))
 
/* Call the TI program KAPEQEN                                      */
             CHGVAR     VAR(&LENGTH) VALUE(20)
             CHGVAR     VAR(&SEND) VALUE('*PROP     ' *CAT &MESGS)
             CALL       PGM(KAPEQEN) PARM(&SEND &LENGTH)
 
/* If &MESGS is 'STOP' then call the TI program KAPENEQ */
             IF         COND(&MESGS *EQ 'STOP      ' *AND &CALLER +
                          *EQ 'SCMENUF   ') THEN(DO)
             CHGVAR     VAR(&LENGTH) VALUE(0)
             CALL       PGM(KAPENEQ) PARM(&RESPONSE &LENGTH)
 
/* If &RESPONSE is not 'STOPPED' or &LENGTH is zero then error */
              IF         COND((%SUBSTRING(&RESPONSE 11 17) *NE +
                          'STOPPED') *OR (&LENGTH *EQ 0)) THEN(DO)
             SNDPGMMSG  MSG('TI failed to respond') TOMSGQ(MRUNQ +
                          MOPERQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/* Abnormal termination  */
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('TIC0030 +
                          - Stop & Start the SD Replication Task in +
                          the TI/CSCS ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
