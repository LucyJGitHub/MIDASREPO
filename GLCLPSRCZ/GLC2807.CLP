/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Fontis File Transfer process check')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Midas-Fontis Interface                              */
/*                                                                   */
/*       GLC2807 - TCP/IP FTP TRANSMISSION                           */
/*                                                                   */
/*       Function : This program performs the FTP Transmission       */
/*                  to a remote machine and checks the result of     */
/*                  connection between the two systems.              */
/*                                                                   */
/*       Submitted By : MSC3001 - MS Compression/Transmission        */
/*                                                                   */
/*       Calls : GL2807 - Fontis File Transfer Process Check         */
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
/*       Prev Amend No.  CGL004 *CREATE    Date 24FEB97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CGL004 - Midas-Fontis Interface                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&HOST &MAXTRY &RTCD)
 
/**  Copyright statement definition                                */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/**  Declare variables                                             */
 
             DCL        VAR(&HOST)     TYPE(*CHAR) LEN(30)
             DCL        VAR(&MAXTRY)   TYPE(*DEC)  LEN(1)
             DCL        VAR(&RTCD)     TYPE(*CHAR) LEN(7)
 
             DCL        VAR(&MODE)     TYPE(*CHAR) LEN(7) VALUE(' ')
             DCL        VAR(&RETRY)    TYPE(*DEC)  LEN(1)
 
/**  Global Error Monitor Message                                  */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO ABNOR)
             CHGJOB     SWS(XXXXXX00)
             CHGVAR     VAR(&RETRY) VALUE(0)
 
 
START:
/** Clear Output File                                              */
             CLRPFM     FILE(GLFOOTPD)
 
/** Override FTP files  INPUT & OUTPUT                             */
 
             OVRDBF     FILE(INPUT)  TOFILE(GLFOINPD)
             OVRDBF     FILE(OUTPUT) TOFILE(GLFOOTPD)
 
/** Start TCP/IP FTP function                                      */
             STRTCPFTP  RMTSYS(&HOST)
 
/** Read the FTP Output file                                       */
 
             CHGVAR     VAR(&MODE) VALUE('SEND')
             CHGVAR     VAR(&RTCD) VALUE(' ')
             CALL       PGM(GL2807) PARM(&MODE &RTCD)
             DLTOVR     FILE(*ALL)
 
/* If either job user switches 7 or 8 are on, perform abnormal */
/* termination processing */
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
               SNDPGMMSG  MSG('FTP Output Monitor ended abnormally') +
               TOPGMQ(*PRV) TOMSGQ(MRUNQ MOPERQ)
                        GOTO       CMDLBL(ABNOR)
             ENDDO
 
 
/** If the FTP operation failed due to an incorrect remote user id */
/** and password combination - send a message to the user and      */
/** goto ABNOR                                                     */
 
             IF         COND(&RTCD *EQ 'LOGIN') THEN(DO)
               SNDPGMMSG  MSG('Login Failed - Check Userid/Password') +
               TOPGMQ(*PRV) TOMSGQ(MRUNQ MOPERQ)
                        GOTO       CMDLBL(ABNOR)
             ENDDO
 
/** If the FTP operation failed, wait and then retry               */
 
             IF         COND(&RTCD *EQ 'FAILED') THEN(DO)
                        CHGVAR     VAR(&RETRY) VALUE(&RETRY + 1)
 
                        IF   COND(&RETRY *LT &MAXTRY) THEN(DO)
                        GOTO       CMDLBL(START)
                        ENDDO
 
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/* Abnormal Processing */
 
 ABNOR:      IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                        CHGJOB  SWS(XXXXXX11)
                        MONMSG  MSGID(CPF0000 MCH0000)
                        DMPCLPGM
                        MONMSG  MSGID(CPF0000 MCH0000)
             ENDDO
 
             SNDPGMMSG  MSG('GLC2807 - Fontis File Transfer Protocol +
                          Functions - ABNORMAL TERMINATION') +
                          TOPGMQ(*PRV) TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/** End of program                                                 */
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
