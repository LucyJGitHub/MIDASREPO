/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GO Universal transactions upd: t-splt srvr')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GOCXCL002 - Midas GO Extract Controller Customer Loans      */
/*                   Task Split Server                               */
/*                                                                   */
/*       (c) Misys Banking Systems Ltd. 2009                         */
/*                                                                   */
/*       Last Amend No. AR1081071          Date 22Jan12              */
/*       Prev Amend No. CGO001AC           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      CGP014  *Create    Date 27Feb09              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       AR1081071 - Task split GOCXCLTS failed                      */
/*                   Modify processing for No Record Found           */
/*       CGO001AC - COB Restructure - GO COB Optimisation Phase 1    */
/*       CGP014 - Task split of Extract Controller, Customer Loans   */
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
                          VALUE(XCLNDVPD)
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTAQLIBL) TYPE(*CHAR) LEN(10) +
                          VALUE('*LIBL     ')
             DCL        VAR(&MSGLENGTH) TYPE(*DEC) LEN(5 0) VALUE(50)
             DCL        VAR(&MSGDATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&SNDDTAQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RCVDTAQ) TYPE(*CHAR) LEN(10) +
                          VALUE('GOXCLNSRV')
             DCL        VAR(&RCVWAIT) TYPE(*DEC) LEN(5 0) VALUE(-1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2009')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Send message to MRUNQ */
 
             SNDPGMMSG  MSG('GOCXCL002 - Midas GO Extract Controller +
                          Customer Loans - Task Split Server') +
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
 
             CALL       PGM(GOXCL002) PARM(&COPY_RECS &RTN_CODE)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Set up data queue and message data */
 
/**********  IF         COND(&RTN_CODE *NE 'NRF') THEN(DO)         */         /*CGO001AC AR1081071*/
             CHGVAR     VAR(&SNDDTAQ) VALUE(&MEMBER)
             CHGVAR     VAR(&MSGDATA) VALUE('PROMPT')
/**********  ENDDO                                                 */         /*CGO001AC AR1081071*/
 
/* Send message data to data queue */
 
             IF         COND(&RTN_CODE *NE 'NRF') THEN(DO)                             /*AR1081071*/
             CALL       PGM(QSNDDTAQ) PARM(&SNDDTAQ &DTAQLIBL +
                          &MSGLENGTH &MSGDATA)
             ENDDO                                                                     /*AR1081071*/
 
/* If return code = EOF, set restart status to 'N' and terminate */
 
/**********  IF         COND(&RTN_CODE = 'EOF') THEN(DO)           */                   /*CGO001AC*/
             IF         COND(&RTN_CODE *EQ 'EOF' *OR &RTN_CODE *EQ +
                          'NRF') THEN(DO)                                               /*CGO001AC*/
 
             CHGVAR     VAR(&STAT) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAME &CSEQ &STAT)
 
             GOTO       CMDLBL(END)
 
             ENDDO
 
/* If return code <> EOF, wait for another data queue entry */
 
             GOTO       CMDLBL(RECEIVE)
 
 ABNOR:      SNDPGMMSG  MSG('Program GOCXCL002 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
 
             ENDPGM
