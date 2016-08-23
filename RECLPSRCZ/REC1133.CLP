/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Calculate Fixed Commission Gen-End Proc')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC1133 - Calculate Fixed Commission - End Proc             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CCB003  *Create    Date 05NOV96              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CCB003 - COB Performance Enhancements - Task Split          */
/*                End Proc                                           */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,REC1133INT                                          */
 
/* Declare variables */
 
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTAQLIBL) TYPE(*CHAR) LEN(10) +
                          VALUE('*LIBL     ')
             DCL        VAR(&MSGLENGTH) TYPE(*DEC) LEN(5 0) VALUE(50)
             DCL        VAR(&MSGDATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&SNDDTAQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RCVDTAQ) TYPE(*CHAR) LEN(10) +
                          VALUE('FIXCMSERVE')
             DCL        VAR(&RCVWAIT) TYPE(*DEC) LEN(5 0) VALUE(-1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,REC1133MPS                                          */
 
/* Send message to MRUNQ */
             SNDPGMMSG  MSG('REC1133 - Calculate Fixed Commission - +
                          End Proc') TOMSGQ(MRUNQ)
 
/* Retrieve first member description */
 
             RTVMBRD    FILE(REFIXCPD) RTNMBR(&MEMBER)
 
/* Set up data queue and message data */
 
             CHGVAR     VAR(&SNDDTAQ) VALUE(&MEMBER)
             CHGVAR     VAR(&MSGDATA) VALUE('END')
 
/* Send message data to data queue */
 
 LOOP:       CALL       PGM(QSNDDTAQ) PARM(&SNDDTAQ &DTAQLIBL +
                          &MSGLENGTH &MSGDATA)
 
/* Retrieve next member description */
 
             RTVMBRD    FILE(REFIXCPD) MBR(&MEMBER *NEXT) +
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
 
 ABNOR:      SNDPGMMSG  MSG('Program REC1133 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,REC1133END                                          */
 
             ENDPGM
