/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GO Universal transactions upd: t-s End Proc')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GOCXCL003 - Midas GO Extract Controller Customer Loans      */
/*                   End Process                                     */
/*                                                                   */
/*       (c) Finastra International Limited 2009                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. CGP014  *CREATE    Date 27Feb09              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CGP014 - Task split of Extract Controller, Customer Loans   */
/*                                                                   */
/*********************************************************************/
             PGM
 
/* Declare variables */
 
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
                          Finastra International Limited +
                          2009')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Send message to MRUNQ */
             SNDPGMMSG  MSG('GOCXCL003 - Midas GO Extract Controller +
                          Customer Loans - End Process') TOMSGQ(MRUNQ)
 
/* Retrieve first member description */
 
             RTVMBRD    FILE(&DRIVER) RTNMBR(&MEMBER)
 
/* Set up data queue and message data */
 
             CHGVAR     VAR(&SNDDTAQ) VALUE(&MEMBER)
             CHGVAR     VAR(&MSGDATA) VALUE('END')
 
/* Send message data to data queue */
 
 LOOP:       CALL       PGM(QSNDDTAQ) PARM(&SNDDTAQ &DTAQLIBL +
                          &MSGLENGTH &MSGDATA)
 
/* Retrieve next member description */
 
             RTVMBRD    FILE(&DRIVER) MBR(&MEMBER *NEXT) +
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
 
 ABNOR:      SNDPGMMSG  MSG('Program GOCXCL003 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
