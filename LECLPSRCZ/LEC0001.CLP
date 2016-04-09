/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE MQSeries object creation utility control')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC0001 - MQSeries Object Creation Utility Control          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*       Last Amend No. 210893  *CREATE    Date 24May01              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       210893 - MQSeries Object Creation Utility                   */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2002')
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DATE) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&CTIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TIME) TYPE(*DEC) LEN(6 0)
 
             DCL        VAR(&MAKOBJ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LENGTH) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&MESS) TYPE(*CHAR) LEN(78) VALUE(' ')
 
             DCL        VAR(&BRCH) TYPE(*CHAR) LEN(3)
             DCL        VAR(&ASNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRVNAM) TYPE(*CHAR) LEN(15)
             DCL        VAR(&GENAUD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&STARTPOS) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&ASTOSRV) TYPE(*CHAR) LEN(29)
             DCL        VAR(&TMQNAM) TYPE(*CHAR) LEN(22)
             DCL        VAR(&SRVTOAS) TYPE(*CHAR) LEN(29)
             DCL        VAR(&TXT1) TYPE(*CHAR) LEN(56)
             DCL        VAR(&TXT2) TYPE(*CHAR) LEN(43)
             DCL        VAR(&TXT3) TYPE(*CHAR) LEN(61)
             DCL        VAR(&TXT4) TYPE(*CHAR) LEN(60)
             DCL        VAR(&BRCHSYSB) TYPE(*CHAR) LEN(30)
             DCL        VAR(&BRCHSYSR) TYPE(*CHAR) LEN(30)
             DCL        VAR(&BRCHSYST) TYPE(*CHAR) LEN(30)
             DCL        VAR(&BRCHSYSTR) TYPE(*CHAR) LEN(30)
 
/* Declare display file */
 
             DCLF       FILE(LE0001DF)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGJOB     SWS(XXXXXX00)
 
 
/* Get user name, machine name, date and time  */
 
             RTVJOBA    USER(&USER)
             RTVNETA    SYSNAME(&SYSID)
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&CDATE)
             CHGVAR     VAR(&DATE) VALUE(&CDATE)
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&CTIME)
             CHGVAR     VAR(&TIME) VALUE(&CTIME)
 
/* Delete data area LEC001 if it exists, then set up a new one */
 
             DLTDTAARA  DTAARA(QTEMP/LEC001)
             MONMSG     MSGID(CPF0000)
             CRTDTAARA  DTAARA(QTEMP/LEC001) TYPE(*CHAR) LEN(256) +
                          AUT(*ALL)
 
/* Output screen, and get user input */
REDISP:
             SNDRCVF    DEV(*FILE) RCDFMT(MQPARM) WAIT(*YES)
 
/* Check for F3 - if pressed, exit program */
 
             IF         COND(&IN03 *EQ '1') THEN(DO)
                GOTO       CMDLBL(END)
             ENDDO
 
/* Check that prefix and branch have no blanks in them, and that the server and */
/* AS/400 fields have had something entered.                                    */
 
/* Prefix validation */
 
             CHGVAR     VAR(&LENGTH) VALUE(2)
             CALL       PGM(LE0013) PARM(&LENGTH &PREFIX)
 
/* If an error has been detected, send a message, and redisplay the entry screen */
 
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                CHGJOB     SWS(XXXXXX0X)
                CHGVAR     VAR(&MESS) VALUE('Prefix field cannot have +
                             any blanks')
                GOTO       CMDLBL(REDISP)
             ENDDO
             ELSE       CMD(DO)
                CHGVAR     VAR(&MESS) VALUE(' ')
             ENDDO
 
/* Branch validation */
 
             CHGVAR     VAR(&LENGTH) VALUE(3)
             CALL       PGM(LE0013) PARM(&LENGTH &BRCH)
 
/* If an error has been detected, send a message, and redisplay the entry screen */
 
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                CHGJOB     SWS(XXXXXX0X)
                CHGVAR     VAR(&MESS) VALUE('Branch field cannot have +
                             any blanks')
                GOTO       CMDLBL(REDISP)
             ENDDO
             ELSE       CMD(DO)
                CHGVAR     VAR(&MESS) VALUE(' ')
             ENDDO
 
/* iSeries validation */
 
             CHGVAR     VAR(&LENGTH) VALUE(1)
             CALL       PGM(LE0013) PARM(&LENGTH &ASNAME)
 
/* If an error has been detected, send a message, and redisplay the entry screen */
 
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                CHGJOB     SWS(XXXXXX0X)
                CHGVAR     VAR(&MESS) VALUE('AS/400 field cannot be +
                             blank')
                GOTO       CMDLBL(REDISP)
             ENDDO
             ELSE       CMD(DO)
                CHGVAR     VAR(&MESS) VALUE(' ')
             ENDDO
 
/* Server validation */
 
             CHGVAR     VAR(&LENGTH) VALUE(1)
             CALL       PGM(LE0013) PARM(&LENGTH &SRVNAM)
 
/* If an error has been detected, send a message, and redisplay the entry screen */
 
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                CHGJOB     SWS(XXXXXX0X)
                CHGVAR     VAR(&MESS) VALUE('Server field cannot be +
                             blank')
                GOTO       CMDLBL(REDISP)
             ENDDO
             ELSE       CMD(DO)
                CHGVAR     VAR(&MESS) VALUE(' ')
             ENDDO
 
/* Set up variables for commands */
 
/* Data area starting position */
             CHGVAR     VAR(&STARTPOS) VALUE(1)
 
/* AS400.TO.SERVER information */
             CHGVAR     VAR(&ASTOSRV) VALUE(&ASNAME *TCAT '.TO.' +
                          *TCAT &SRVNAM)
 
/* MQ Series TCP/IP channel to SERVER Loan Manager text */
             CHGVAR     VAR(&TXT1) VALUE('MQ Series TCP/IP channel +
                          to' *BCAT &SRVNAM *BCAT 'Loan Manager')
 
/* SERVER.XMIT.Q data */
             CHGVAR     VAR(&TMQNAM) VALUE(&SRVNAM *TCAT '.XMIT.Q')
 
/* SERVER.TO.AS400 information */
             CHGVAR     VAR(&SRVTOAS) VALUE(&SRVNAM *TCAT '.TO.' +
                          *TCAT &ASNAME)
 
/* MQ Series TCP/IP channel from SERVER Loan Manager text */
             CHGVAR     VAR(&TXT2) VALUE('MQ Series TCP/IP channel +
                          from' *BCAT &SRVNAM *BCAT 'Loan Manager')
 
/* £BRANCH + SYSTEM].BULK information */
             CHGVAR     VAR(&BRCHSYSB) VALUE(&BRCH *TCAT +
                          &PREFIX *TCAT '.BULK')
 
/* £BRANCH + SYSTEM].RPLY information */
             CHGVAR     VAR(&BRCHSYSR) VALUE(&BRCH *TCAT +
                          &PREFIX *TCAT '.RPLY')
 
/* £BRANCH + SYSTEM].TRIC information */
             CHGVAR     VAR(&BRCHSYST) VALUE(&BRCH *TCAT +
                          &PREFIX *TCAT '.TRIC')
 
/* £BRANCH + SYSTEM].TRAN information */
             CHGVAR     VAR(&BRCHSYSTR) VALUE(&BRCH *TCAT +
                          &PREFIX *TCAT '.TRAN')
 
/* MQ Queue for receiving data from SERVER Loan Manager text */
             CHGVAR     VAR(&TXT3) VALUE('MQ Queue for receiving d+
                          ata from' *BCAT &SRVNAM *BCAT 'Loan Manager')
 
/* MQ Series Transmission Queue to SERVER Loan Manager text */
             CHGVAR     VAR(&TXT4) VALUE('MQ Series Transmission Queue +
                          to' *BCAT &SRVNAM *BCAT 'Loan Manager')
 
/* Begin running creation commands, if option to create has been selected */
 
             IF         COND(&MAKOBJ *EQ 'Y') THEN(DO)
 
/* Create the sending channel  */
                CRTMQMCHL  CHLNAME(&ASTOSRV) CHLTYPE(*SDR) +
                             TRPTYPE(*TCP) TEXT(&TXT1) +
                             CONNAME(&SRVNAM) TMQNAME(&TMQNAM) +
                             DSCITV(0) CVTMSG(*YES)
 
/* Check for errors on running command */
 
                MONMSG     MSGID(CPF0001) EXEC(DO)
                   RCVMSG     MSGTYPE(*DIAG) MSGID(&ERROR)
                   CHGDTAARA  DTAARA(QTEMP/LEC001 (&STARTPOS 10)) +
                                VALUE(&ERROR)
                   GOTO       CMDLBL(ERR1)
                ENDDO
 
                MONMSG     MSGID(CPF0000) EXEC(DO)
                CHGVAR     VAR(&ERROR) VALUE('UNKNOWN')
                CHGDTAARA  DTAARA(QTEMP/LEC001 (&STARTPOS 10)) +
                             VALUE(&ERROR)
                GOTO       CMDLBL(ERR1)
             ENDDO
 
/* If no errors found, queue has been created */
 
             CHGVAR     VAR(&ERROR) VALUE('CREATED')
             CHGDTAARA  DTAARA(QTEMP/LEC001 (&STARTPOS 10)) +
                          VALUE(&ERROR)
ERR1:
 
/* Move on to next section of data area */
 
             CHGVAR     VAR(&STARTPOS) VALUE(&STARTPOS + 10)
 
/* Create the receiving channel  */
             CRTMQMCHL  CHLNAME(&SRVTOAS) CHLTYPE(*RCVR) +
                          TRPTYPE(*TCP) TEXT(&TXT2)
 
/* Check for errors on running command */
 
             MONMSG     MSGID(CPF0001) EXEC(DO)
                RCVMSG     MSGTYPE(*DIAG) MSGID(&ERROR)
                CHGDTAARA  DTAARA(QTEMP/LEC001 (&STARTPOS 10)) +
                             VALUE(&ERROR)
                GOTO       CMDLBL(ERR2)
             ENDDO
 
             MONMSG     MSGID(CPF0000) EXEC(DO)
                CHGVAR     VAR(&ERROR) VALUE('UNKNOWN')
                CHGDTAARA  DTAARA(QTEMP/LEC001 (&STARTPOS 10)) +
                             VALUE(&ERROR)
                GOTO       CMDLBL(ERR2)
             ENDDO
 
/* If no errors found, queue has been created */
 
             CHGVAR     VAR(&ERROR) VALUE('CREATED')
             CHGDTAARA  DTAARA(QTEMP/LEC001 (&STARTPOS 10)) +
                          VALUE(&ERROR)
 
ERR2:
 
/* Move on to next section of data area */
 
             CHGVAR     VAR(&STARTPOS) VALUE(&STARTPOS + 10)
 
/* Create the bulk download queue */
             CRTMQMQ    QNAME(&BRCHSYSB) QTYPE(*RMT) TEXT('Bulk +
                          download queue') DFTPTY(1) +
                          DFTMSGPST(*YES) RMTQNAME(&BRCHSYSB) +
                          RMTMQMNAME(&SRVNAM) TMQNAME(&TMQNAM)
 
/* Check for errors on running command */
 
             MONMSG     MSGID(CPF0001) EXEC(DO)
                RCVMSG     MSGTYPE(*DIAG) MSGID(&ERROR)
                CHGDTAARA  DTAARA(QTEMP/LEC001 (&STARTPOS 10)) +
                             VALUE(&ERROR)
                GOTO       CMDLBL(ERR3)
             ENDDO
 
             MONMSG     MSGID(CPF0000) EXEC(DO)
                CHGVAR     VAR(&ERROR) VALUE('UNKNOWN')
                CHGDTAARA  DTAARA(QTEMP/LEC001 (&STARTPOS 10)) +
                             VALUE(&ERROR)
                GOTO       CMDLBL(ERR3)
             ENDDO
 
/* If no errors found, queue has been created */
 
             CHGVAR     VAR(&ERROR) VALUE('CREATED')
             CHGDTAARA  DTAARA(QTEMP/LEC001 (&STARTPOS 10)) +
                          VALUE(&ERROR)
ERR3:
 
/* Move on to next section of data area */
 
             CHGVAR     VAR(&STARTPOS) VALUE(&STARTPOS + 10)
 
/* Create the reply queue */
             CRTMQMQ    QNAME(&BRCHSYSR) QTYPE(*RMT) TEXT('Reply +
                          queue') DFTPTY(1) DFTMSGPST(*YES) +
                          RMTQNAME(&BRCHSYSR) RMTMQMNAME(&SRVNAM) +
                          TMQNAME(&TMQNAM)
 
/* Check for errors on running command */
 
             MONMSG     MSGID(CPF0001) EXEC(DO)
                RCVMSG     MSGTYPE(*DIAG) MSGID(&ERROR)
                CHGDTAARA  DTAARA(QTEMP/LEC001 (&STARTPOS 10)) +
                             VALUE(&ERROR)
                GOTO       CMDLBL(ERR4)
             ENDDO
 
             MONMSG     MSGID(CPF0000) EXEC(DO)
                CHGVAR     VAR(&ERROR) VALUE('UNKNOWN')
                CHGDTAARA  DTAARA(QTEMP/LEC001 (&STARTPOS 10)) +
                             VALUE(&ERROR)
                GOTO       CMDLBL(ERR4)
             ENDDO
 
/* If no errors found, queue has been created */
 
             CHGVAR     VAR(&ERROR) VALUE('CREATED')
             CHGDTAARA  DTAARA(QTEMP/LEC001 (&STARTPOS 10)) +
                          VALUE(&ERROR)
ERR4:
 
/* Move on to next section of data area */
 
             CHGVAR     VAR(&STARTPOS) VALUE(&STARTPOS + 10)
 
/* Create the trickle queue */
             CRTMQMQ    QNAME(&BRCHSYST) QTYPE(*RMT) TEXT('Trickle +
                          queue') DFTPTY(0) DFTMSGPST(*YES) +
                          RMTQNAME(&BRCHSYST) RMTMQMNAME(&SRVNAM) +
                          TMQNAME(&TMQNAM)
 
/* Check for errors on running command */
 
             MONMSG     MSGID(CPF0001) EXEC(DO)
                RCVMSG     MSGTYPE(*DIAG) MSGID(&ERROR)
                CHGDTAARA  DTAARA(QTEMP/LEC001 (&STARTPOS 10)) +
                             VALUE(&ERROR)
                GOTO       CMDLBL(ERR5)
             ENDDO
 
             MONMSG     MSGID(CPF0000) EXEC(DO)
                CHGVAR     VAR(&ERROR) VALUE('UNKNOWN')
                CHGDTAARA  DTAARA(QTEMP/LEC001 (&STARTPOS 10)) +
                             VALUE(&ERROR)
                GOTO       CMDLBL(ERR5)
             ENDDO
 
/* If no errors found, queue has been created */
 
             CHGVAR     VAR(&ERROR) VALUE('CREATED')
             CHGDTAARA  DTAARA(QTEMP/LEC001 (&STARTPOS 10)) +
                          VALUE(&ERROR)
ERR5:
 
/* Move on to next section of data area */
 
             CHGVAR     VAR(&STARTPOS) VALUE(&STARTPOS + 10)
 
/* Create the queue to receive transactions from loan manager */
             CRTMQMQ    QNAME(&BRCHSYSTR) QTYPE(*LCL) TEXT(&TXT3) +
                          DFTPTY(1) DFTMSGPST(*YES)
 
/* Check for errors on running command */
 
             MONMSG     MSGID(CPF0001) EXEC(DO)
                RCVMSG     MSGTYPE(*DIAG) MSGID(&ERROR)
                CHGDTAARA  DTAARA(QTEMP/LEC001 (&STARTPOS 10)) +
                             VALUE(&ERROR)
                GOTO       CMDLBL(ERR6)
             ENDDO
 
             MONMSG     MSGID(CPF0000) EXEC(DO)
                CHGVAR     VAR(&ERROR) VALUE('UNKNOWN')
                CHGDTAARA  DTAARA(QTEMP/LEC001 (&STARTPOS 10)) +
                             VALUE(&ERROR)
                GOTO       CMDLBL(ERR6)
             ENDDO
 
/* If no errors found, queue has been created */
 
             CHGVAR     VAR(&ERROR) VALUE('CREATED')
             CHGDTAARA  DTAARA(QTEMP/LEC001 (&STARTPOS 10)) +
                          VALUE(&ERROR)
ERR6:
 
/* Move on to next section of data area */
 
             CHGVAR     VAR(&STARTPOS) VALUE(&STARTPOS + 10)
 
/* Create the transmission queue */
             CRTMQMQ    QNAME(&TMQNAM) QTYPE(*LCL) TEXT(&TXT4) +
                          DFTPTY(1) DFTMSGPST(*YES) TRGENBL(*YES) +
                          MAXDEPTH(24000) USAGE(*TMQ)
 
/* Check for errors on running command */
 
             MONMSG     MSGID(CPF0001) EXEC(DO)
                RCVMSG     MSGTYPE(*DIAG) MSGID(&ERROR)
                CHGDTAARA  DTAARA(QTEMP/LEC001 (&STARTPOS 10)) +
                             VALUE(&ERROR)
                GOTO       CMDLBL(ERR7)
             ENDDO
 
             MONMSG     MSGID(CPF0000) EXEC(DO)
                CHGVAR     VAR(&ERROR) VALUE('UNKNOWN')
                CHGDTAARA  DTAARA(QTEMP/LEC001 (&STARTPOS 10)) +
                             VALUE(&ERROR)
                GOTO       CMDLBL(ERR7)
             ENDDO
 
/* If no errors found, queue has been created */
 
             CHGVAR     VAR(&ERROR) VALUE('CREATED')
             CHGDTAARA  DTAARA(QTEMP/LEC001 (&STARTPOS 10)) +
                          VALUE(&ERROR)
ERR7:
 
             ENDDO
 
/* Call RPG audit program, if audit report option has been takem */
 
             IF         COND(&GENAUD *EQ 'Y') THEN(DO)
                CALL       PGM(LE0001) PARM(&ASTOSRV &SRVTOAS &BRCHSYSB +
                             &BRCHSYSR &BRCHSYST &BRCHSYSTR &TMQNAM)
             ENDDO
 
/* Database error processing for RPG */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
