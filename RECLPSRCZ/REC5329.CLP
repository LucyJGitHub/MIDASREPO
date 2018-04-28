/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE Fixed Accnt Charges Gen-Task Split Server')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC5329 - Fixed Account Charges Generation - Task Split     */
/*                 Server.                                           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CRE083BC             Date 06Aug12            */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK009             Date 09Aug99              */
/*                      CCB003  *Create    Date 23OCT96              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CRE083BC - COB Restructure - RE COB Optimisation Phase 1    */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       CCB003 - COB Performance Enhancements - Task Split          */
/*                Task Split Server                                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAME &CSEQ &COPY_RECS)
 
/*/COPY WNCPYSRC,REC5329INT                                          */
 
/* Declare file and variables */
 
             DCLF       FILE(TABTBRE)
 
             DCL        VAR(&CNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&COPY_RECS) TYPE(*DEC) LEN(7 0)
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(3)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTAQLIBL) TYPE(*CHAR) LEN(10) +
                          VALUE('*LIBL     ')
             DCL        VAR(&MSGLENGTH) TYPE(*DEC) LEN(5 0) VALUE(50)
             DCL        VAR(&MSGDATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&SNDDTAQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RCVDTAQ) TYPE(*CHAR) LEN(10) +
                          VALUE('FACHGSERVE')
             DCL        VAR(&RCVWAIT) TYPE(*DEC) LEN(5 0) VALUE(-1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,REC5329MPS                                          */
 
/* If Fixed Account Charge Generation Flag is not 'Y', terminate  */
/* the program. */
 
             RCVF
 
             IF         COND(&FACH *NE 'Y') THEN(DO)
             GOTO       CMDLBL(END)
             ENDDO
 
/* Send message to MRUNQ */
 
             SNDPGMMSG  MSG('REC5329 - Fixed Account Charges +
                          Generation - Task Split Server') +
                          TOMSGQ(MRUNQ)
 
/* Start commitment control */
 
/**********  STRCMTCTL  LCKLVL(*CHG)                                  /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)                   /*CPK009*/
 
/* Read COB components file to check the restart status */
 
             CALL       PGM(CB0160) PARM(&CNAME &CSEQ &STAT)
 
/* Check if any problems with COB components file */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* If restart status = Y, send message to each sub-task data queue */
 
             IF         COND(&STAT = 'Y') THEN(DO)
 
/* Retrieve first member description */
 
             RTVMBRD    FILE(REFACGPD) RTNMBR(&MEMBER)
 
/* Set up data queue and message data */
 
             CHGVAR     VAR(&SNDDTAQ) VALUE(&MEMBER)
             CHGVAR     VAR(&MSGDATA) VALUE('RESTART')
 
/* Send message data to data queue */
 
 LOOP:       CALL       PGM(QSNDDTAQ) PARM(&SNDDTAQ &DTAQLIBL +
                          &MSGLENGTH &MSGDATA)
 
/* Retrieve next member description */
 
             RTVMBRD    FILE(REFACGPD) MBR(&MEMBER *NEXT) +
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
 
/* Override driving file */
 
             OVRDBF     FILE(REFACGPD) TOFILE(REFACGPD) MBR(&MEMBER)
             OVRDBF     FILE(REFACGPA) TOFILE(REFACGPA) MBR(&MEMBER)
             CLRPFM     FILE(REFACGPD) MBR(&MEMBER)                                     /*CRE083BC*/
 
/* Call the program to copy records to specified member */
 
             CALL       PGM(RE5329) PARM(&COPY_RECS &RTN_CODE)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Set up data queue and message data */
 
             IF         COND(&RTN_CODE *NE 'NRF') THEN(DO)                              /*CRE083BC*/
             CHGVAR     VAR(&SNDDTAQ) VALUE(&MEMBER)
             CHGVAR     VAR(&MSGDATA) VALUE('PROMPT')
 
/* Send message data to data queue */
 
             CALL       PGM(QSNDDTAQ) PARM(&SNDDTAQ &DTAQLIBL +
                          &MSGLENGTH &MSGDATA)
             ENDDO                                                                      /*CRE083BC*/
 
/* If return code = EOF, set restart status to 'N' and terminate */
 
/**********  IF         COND(&RTN_CODE = 'EOF') THEN(DO)           */                   /*CRE083BC*/
             IF         COND(&RTN_CODE *EQ 'EOF' *OR &RTN_CODE *EQ +
                          'NRF') THEN(DO)                                               /*CRE083BC*/
 
             CHGVAR     VAR(&STAT) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAME &CSEQ &STAT)
 
             GOTO       CMDLBL(END)
 
             ENDDO
 
/* If return code <> EOF, wait for another data queue entry */
 
             GOTO       CMDLBL(RECEIVE)
 
 ABNOR:      SNDPGMMSG  MSG('Program REC5329 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,REC5329END                                          */
 
             ENDPGM
