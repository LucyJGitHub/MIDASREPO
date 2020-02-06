/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE Capitalisation - task split server ANWD')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC3131 - Commission Capitalisation - Task Split Server     */
/*                 ANWD Version                                      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CRE083BD           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      204111             Date 25Mar02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      CCB003  *Create    Date 01Apr97              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CRE083BD - COB Restructure - RE COB Optimisation Phase 1    */
/*       204111 - Correct coding in IF statement                     */
/*              - Applied fix 185958.                                */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       CCB003 - COB Performance Enhancements - Task Split          */
/*                Task Split Server                                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAME &CSEQ &COPY_RECS)
 
/*/COPY WNCPYSRC,REC3131INT                                          */
 
/* Declare variables */
 
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
                          VALUE('COMMCSERVE')
             DCL        VAR(&RCVWAIT) TYPE(*DEC) LEN(5 0) VALUE(-1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCLF       FILE(TABTBRE)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RCVF       RCDFMT(TABTBREF)
 
/**********  IF         COND(*NOT (&CHOV = 'Y' *OR &CDTO = 'Y' *OR +  /*204111*/
/**********               &FXAC = 'Y' *OR &CNDS = 'Y' & CDRI = 'Y' +  /*204111*/
/**********               *OR &CMBL = 'Y' & CINA = 'Y' *OR &VATP = +  /*204111*/
/**********               'Y')) THEN(DO)                              /*204111*/
             IF         COND(*NOT (&CHOV = 'Y' *OR &CDTO = 'Y' *OR +
                          &FXAC = 'Y' *OR &CNDS = 'Y' *OR &CDRI = 'Y' +
                          *OR &CMBL = 'Y' *OR &CINA = 'Y' *OR &VATP = +
                          'Y')) THEN(DO)                              /*204111*/
             GOTO       CMDLBL(END)
 
             ENDDO
 
/*/COPY WNCPYSRC,REC3131MPS                                          */
 
/* Send message to MRUNQ */
 
             SNDPGMMSG  MSG('REC3131 - Commission Capitalisation - +
                          Task Split Server') TOMSGQ(MRUNQ)
 
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
 
             RTVMBRD    FILE(RECOMCPD) RTNMBR(&MEMBER)
 
/* Set up data queue and message data */
 
             CHGVAR     VAR(&SNDDTAQ) VALUE(&MEMBER)
             CHGVAR     VAR(&MSGDATA) VALUE('RESTART')
 
/* Send message data to data queue */
 
 LOOP:       CALL       PGM(QSNDDTAQ) PARM(&SNDDTAQ &DTAQLIBL +
                          &MSGLENGTH &MSGDATA)
 
/* Retrieve next member description */
 
             RTVMBRD    FILE(RECOMCPD) MBR(&MEMBER *NEXT) +
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
 
             OVRDBF     FILE(RECOMCPD) TOFILE(RECOMCPD) MBR(&MEMBER)
             CLRPFM     FILE(RECOMCPD) MBR(&MEMBER)                                     /*CRE083BD*/
             OVRDBF     FILE(RECOMCPA) TOFILE(RECOMCPA) MBR(&MEMBER)
 
/* Call the program to copy records to specified member */
 
             CALL       PGM(RE3121) PARM(&COPY_RECS &RTN_CODE)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Set up data queue and message data */
 
             CHGVAR     VAR(&SNDDTAQ) VALUE(&MEMBER)
             CHGVAR     VAR(&MSGDATA) VALUE('PROMPT')
 
/* Send message data to data queue */
 
             IF         COND(&RTN_CODE *NE 'NRF') THEN(DO)                              /*CRE083BD*/
             CALL       PGM(QSNDDTAQ) PARM(&SNDDTAQ &DTAQLIBL +
                          &MSGLENGTH &MSGDATA)
             ENDDO                                                                      /*CRE083BD*/
 
/* If return code = EOF, set restart status to 'N' and terminate */
 
/**********  IF         COND(&RTN_CODE = 'EOF') THEN(DO)           */                   /*CRE083BD*/
             IF         COND(&RTN_CODE *EQ 'EOF' *OR &RTN_CODE *EQ +
                          'NRF') THEN(DO)                                               /*CRE083BD*/
 
             CHGVAR     VAR(&STAT) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAME &CSEQ &STAT)
 
             GOTO       CMDLBL(END)
 
             ENDDO
 
/* If return code <> EOF, wait for another data queue entry */
 
             GOTO       CMDLBL(RECEIVE)
 
 ABNOR:      SNDPGMMSG  MSG('Program REC3131 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,REC3131END                                          */
 
             ENDPGM
