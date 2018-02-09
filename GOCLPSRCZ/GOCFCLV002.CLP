/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GO Bulk Update of GZFCLTLVPD: t-splt server')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOCFCLV002 - Midas GO Bulk update of Facilities Listview    */
/*                    Task Split Server                              */
/*                                                                   */
/*       (c) Finastra International Limited 2009                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CGO001AB           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      CGP015  *CREATE    Date 06Mar09              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CGO001AB - COB Restructure - GO COB Optimisation Phase 1    */
/*       CGP015 - Task Split of Bulk update of Facilities listview   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAME &CSEQ &COPY_RECS)
 
/* Declare variables */
 
             DCL        VAR(&CNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&COPY_RECS) TYPE(*DEC) LEN(7 0)
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(3)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DRIVER) TYPE(*CHAR) LEN(10) +
                          VALUE(FCLVDVPD)
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTAQLIBL) TYPE(*CHAR) LEN(10) +
                          VALUE('*LIBL     ')
             DCL        VAR(&MSGLENGTH) TYPE(*DEC) LEN(5 0) VALUE(50)
             DCL        VAR(&MSGDATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&SNDDTAQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RCVDTAQ) TYPE(*CHAR) LEN(10) +
                          VALUE('GOFCLVSRV')
             DCL        VAR(&RCVWAIT) TYPE(*DEC) LEN(5 0) VALUE(-1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2009')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Send message to MRUNQ */
 
             SNDPGMMSG  MSG('GOCFCLV002 - Midas GO Bulk update of +
                          Facilities Listview - Task Split Server') +
                          TOMSGQ(MRUNQ)
 
/* Start commitment control */
 
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)
 
/* Read COB components file to check the restart status */
 
             CALL       PGM(CB0160) PARM(&CNAME &CSEQ &STAT)
 
/* Check if any problems with COB components file */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* If restart status = Y, send message to each sub-task data queue */
 
             IF         COND(&STAT = 'Y') THEN(DO)
 
/* Retrieve first member description */
 
             RTVMBRD    FILE(&DRIVER) RTNMBR(&MEMBER)
 
/* Set up data queue and message data */
 
             CHGVAR     VAR(&SNDDTAQ) VALUE(&MEMBER)
             CHGVAR     VAR(&MSGDATA) VALUE('RESTART')
 
/* Send message data to data queue */
 
 LOOP:       CALL       PGM(QSNDDTAQ) PARM(&SNDDTAQ &DTAQLIBL +
                          &MSGLENGTH &MSGDATA)
 
/* Retrieve next member description */
 
             RTVMBRD    FILE(&DRIVER) MBR(&MEMBER *NEXT) +
                          RTNMBR(&SNDDTAQ)
             MONMSG     MSGID(CPF3049) EXEC(GOTO CMDLBL(ENDLOOP))
 
/* Loop for all members in driving file */
 
             CHGVAR     VAR(&MEMBER) VALUE(&SNDDTAQ)
             GOTO       CMDLBL(LOOP)
 
 ENDLOOP:    ENDDO
 
/* Set restart status to 'Y' */
 
             CHGVAR     VAR(&STAT) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAME &CSEQ &STAT)
 
/* Wait for data queue entry */
 
 RECEIVE:    CALL       PGM(QRCVDTAQ) PARM(&RCVDTAQ &DTAQLIBL +
                          &MSGLENGTH &MSGDATA &RCVWAIT)
 
/* Extract member name */
 
             CHGVAR     VAR(&MEMBER) VALUE(%SUBSTRING(&MSGDATA 1 10))
 
/* Override driving file and trailer file */
 
             OVRDBF     FILE(&DRIVER) MBR(&MEMBER) FRCRATIO(500) +
                          NBRRCDS(1000) SEQONLY(*YES 2000)
 
/* Call the program to copy records to specified member */
 
             CALL       PGM(GOFCLV002) PARM(&COPY_RECS &RTN_CODE)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
/* Set up data queue and message data */
 
             CHGVAR     VAR(&SNDDTAQ) VALUE(&MEMBER)
             CHGVAR     VAR(&MSGDATA) VALUE('PROMPT')
 
/* Send message data to data queue */
 
             IF         COND(&RTN_CODE *NE 'NRF') THEN(DO)                              /*CGO001AB*/
             CALL       PGM(QSNDDTAQ) PARM(&SNDDTAQ &DTAQLIBL +
                          &MSGLENGTH &MSGDATA)
             ENDDO                                                                      /*CGO001AB*/
 
/* If return code = EOF, set restart status to 'N' and terminate */
 
/**********  IF         COND(&RTN_CODE = 'EOF') THEN(DO) */                             /*CGO001AB*/
             IF         COND(&RTN_CODE *EQ 'EOF' *OR +
                          &RTN_CODE *EQ 'NRF') THEN(DO)                                 /*CGO001AB*/
 
             CHGVAR     VAR(&STAT) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAME &CSEQ &STAT)
 
             GOTO       CMDLBL(END)
 
             ENDDO
 
/* If return code <> EOF, wait for another data queue entry */
 
             GOTO       CMDLBL(RECEIVE)
 
 ABNOR:      SNDPGMMSG  MSG('Program GOCFCLV002 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
 
             ENDPGM
