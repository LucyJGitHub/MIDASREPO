/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Intrst & Chrges Capitalisat-End Proc')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC6433 - Interest and Charges Capitalisation               */
/*                   (End Proc)                                      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CCB003  *CREATE    Date 01Nov96              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB003 - COB Performance Enhancements - Task Split          */
/*                End Proc                                           */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,REC6433INT                                          */
 
/* Declare variables */
 
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTAQLIBL) TYPE(*CHAR) LEN(10) +
                          VALUE('*LIBL     ')
             DCL        VAR(&MSGLENGTH) TYPE(*DEC) LEN(5 0) VALUE(50)
             DCL        VAR(&MSGDATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&SNDDTAQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RCVDTAQ) TYPE(*CHAR) LEN(10) +
                          VALUE('INTCHSERVE')
             DCL        VAR(&RCVWAIT) TYPE(*DEC) LEN(5 0) VALUE(-1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,REC6403MPS                                          */
 
/* Send message to MRUNQ */
             SNDPGMMSG  MSG('REC6433 - Interest and Charges +
                          Capitalisation - End Proc') TOMSGQ(MRUNQ)
 
/* Retrieve first member description */
 
             RTVMBRD    FILE(REINTCPD) RTNMBR(&MEMBER)
 
/* Set up data queue and message data */
 
             CHGVAR     VAR(&SNDDTAQ) VALUE(&MEMBER)
             CHGVAR     VAR(&MSGDATA) VALUE('END')
 
/* Send message data to data queue */
 
 LOOP:       CALL       PGM(QSNDDTAQ) PARM(&SNDDTAQ &DTAQLIBL +
                          &MSGLENGTH &MSGDATA)
 
/* Retrieve next member description */
 
             RTVMBRD    FILE(REINTCPD) MBR(&MEMBER *NEXT) +
                          RTNMBR(&SNDDTAQ)
             MONMSG     MSGID(CPF3049) EXEC(GOTO CMDLBL(RCVDTAQ))
 
/* Loop for all members in driving file */
 
             CHGVAR     VAR(&MEMBER) VALUE(&SNDDTAQ)
             GOTO       CMDLBL(LOOP)
 
/* Wait for data queue entry */
 
 RCVDTAQ:    CALL       PGM(QRCVDTAQ) PARM(&RCVDTAQ &DTAQLIBL +
                          &MSGLENGTH &MSGDATA &RCVWAIT)
 
/* If message = FINISH, terminate the program */
 
             IF         COND(%SST(&MSGDATA 1 6) = 'FINISH') THEN(DO)
             GOTO       CMDLBL(END)
             ENDDO
             ELSE       CMD(DO)
             GOTO       CMDLBL(RCVDTAQ)
             ENDDO
 
 ABNOR:      SNDPGMMSG  MSG('Program REC6433 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,REC6403END                                          */
 
             ENDPGM
