/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB Restart COB processing')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Close of Business Module.                       */
/*                                                                   */
/*       CBC0101 - Restart COB processing.                           */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK017             Date 28Oct03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01463             Date 11Feb94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK017 - Midas Plus packaging.                              */
/*                Comment out the remove of 'MIDAS' from MSTATUS.    */
/*       S01463 - New program to allow the COB restart processing    */
/*                to be updated without the need to change the       */
/*                subsystem routing entries.                         */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PARM1 &PARM2 &PARM3 &PARM4 &PARM5)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM2) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM3) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM4) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM5) TYPE(*CHAR) LEN(200)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSPECIAL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RSTMSG) TYPE(*CHAR) LEN(132)
             DCL        VAR(&STATMSG) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RPY) TYPE(*CHAR) LEN(1)
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/* Retrieve user identifier */
 
             RTVJOBA    JOB(&JOB) USER(&USER)
 
/* Alter message queue status */
 
             CALL       PGM(SCC2451)
 
/* Send 'EOD' flag to MSGQ/MSPECIAL */
 
             ALCOBJ     OBJ((MSPECIAL *MSGQ *EXCL)) WAIT(9999)
             SNDMSG     MSG('EOD') TOMSGQ(MSPECIAL)
 
/**Remove*this*job's*MIDAS*entry*from*MSGQ/MSTATUS**/ /*                               */ /*CPK017*/
/************                                                                          */ /*CPK017*/
/************CHGMSGQ    MSGQ(MSTATUS) RESET(*YES)                                      */ /*CPK017*/
/************RCVMSG     MSGQ(MSTATUS) RMV(*YES)                                        */ /*CPK017*/
 
/* Check for any other MIDAS entries on MSGQ/MSTATUS */
 
 LOOP1:      CHGMSGQ    MSGQ(MSTATUS) RESET(*YES)
             RCVMSG     MSGQ(MSTATUS) RMV(*NO) MSG(&STATMSG)
 
/* If there are any other MIDAS entries then inform the user */
/* that they cannot continue at present                      */
 
             IF         COND(&STATMSG *NE '     ') THEN(DO)
 LOOP2:         SNDPGMMSG  MSG('Job cannot be run now - do you +
                             wish to re-try - Y or N?') TOMSGQ(&JOB) +
                             MSGTYPE(*INQ)
 
/* Receive user's reply */
 
                RCVMSG     MSGQ(*PGMQ) MSGTYPE(*RPY) WAIT(*MAX) +
                             RMV(*YES) MSG(&RPY)
 
/* If the user wishes to retry */
 
                IF         COND((&RPY *EQ 'Y') *OR (&RPY *EQ 'y')) +
                             THEN(GOTO CMDLBL(LOOP1))
 
/* If the user does not wish to retry */
 
                IF         COND((&RPY *EQ 'N') *OR (&RPY *EQ 'n')) +
                             THEN(GOTO CMDLBL(ABEND))
 
                ELSE       CMD(GOTO CMDLBL(LOOP2))
             ENDDO
 
             DLCOBJ     OBJ((MSPECIAL *MSGQ *EXCL))
 
/* Restart close of business */
 
             CHGVAR     VAR(&RSTMSG) VALUE('Close of Business Run +
                          Restarted by User' *BCAT &USER *BCAT +
                          'from-' *BCAT &JOB)
             SNDPGMMSG  MSG(&RSTMSG) TOMSGQ(MRUNQ MOPERQ)
 
             CALL       PGM(CBRUN)
 
             GOTO       CMDLBL(END)
 
/* Check and reset MSGQ/MSPECIAL */
 
ABEND:
             CHGMSGQ    MSGQ(MSPECIAL) RESET(*YES)
 
             RCVMSG     MSGQ(MSPECIAL) RMV(*NO) MSG(&MSPECIAL)
 
             IF         COND(&MSPECIAL *EQ 'EOD       ') THEN(DO)
                RMVMSG     MSGQ(MSTATUS) CLEAR(*OLD)
             ENDDO
 
             CHGMSGQ    MSGQ(MSPECIAL) RESET(*YES)
 
             DLCOBJ     OBJ((MSPECIAL *MSGQ *EXCL))
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination processing */
 
ABNOR:
             SNDPGMMSG  MSG('Program CBC0101 ended abnormally - job +
                          cancelled') TOMSGQ(&JOB MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             ALCOBJ     OBJ((MSPECIAL *MSGQ *EXCL))
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGMSGQ    MSGQ(MSPECIAL) RESET(*YES)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             RCVMSG     MSGQ(MSPECIAL)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             DLCOBJ     OBJ((MSPECIAL *MSGQ *EXCL))
             MONMSG     MSGID(CPF0000 MCH0000)
 
             SIGNOFF    LOG(*LIST)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
 
 /* Reroute the job back into Midas via MIPGM */
 
             RRTJOB     RTGDTA(MIDASIC)
 
             ENDPGM
