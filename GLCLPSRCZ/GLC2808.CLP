/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Fontis FTP check for accepted files')        */
/********************************************************************/
/*                                                                  */
/*   Midas - Midas-Fontis Interface                                 */
/*                                                                  */
/*   GLC2808    Fontis FTP Check for accepted files                 */
/*                                                                  */
/*       (c) Finastra International Limited 2001                    */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   Prev Amendment No. CGL004 *CREATE   Date 14MAR97               */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*   MD046248 - Finastra Rebranding                                 */
/*   CGL004 - Midas-Fontis Interface                                */
/*                                                                  */
/********************************************************************/
 
             PGM        PARM(&HOST &MAXTRY &RTCD)
 
/* Copyright Statement                                               */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Declare Variables                                                 */
 
             DCL        VAR(&HOST) TYPE(*CHAR) LEN(30)
             DCL        VAR(&MAXTRY) TYPE(*DEC) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&RETRY) TYPE(*DEC) LEN(1)
 
/* Global Message Monitor                                            */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Set off all user job switches                                     */
 
             CHGJOB     SWS(00000000)
 
/* Clear output file                                                 */
 
 START:      CLRPFM     FILE(GLFOLSPD)
 
/* Override default input and output files                           */
 
             OVRDBF     FILE(INPUT) TOFILE(GLFOINPD)
             OVRDBF     FILE(OUTPUT) TOFILE(GLFOLSPD)
 
/* Start TCP function                                                */
 
             STRTCPFTP  RMTSYS(&HOST)
 
/* Call GL2808 to analyse the outptut file                           */
 
             CALL       PGM(GL2808) PARM(&HOST &MAXTRY &RTCD)
 
/* Delete file overrides                                             */
 
             DLTOVR     FILE(*ALL)
 
/* Check for error messages                                         */
/* If job switches 7 or 8 are on, perform abnormal processing       */
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             SNDPGMMSG  MSG('FTP Acceptance Check ended abnormally') +
                          TOPGMQ(*PRV) TOMSGQ(MRUNQ MOPERQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* If the FTP operation failed due to an incorrect remote user id */
/* and password combination - send a message to the user and      */
/* perform abnormal processing.                                   */
 
             IF         COND(&RTCD = 'LOGIN') THEN(DO)
             SNDPGMMSG  MSG('Login Failed, Check Userid/Password') +
                          TOPGMQ(*PRV) TOMSGQ(MRUNQ MOPERQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* If FTP operation failed, wait and then retry                      */
 
             IF         COND(&RTCD = 'FAILED') THEN(DO)
             CHGVAR     VAR(&RETRY) VALUE(&RETRY + 1)
 
               IF         COND(&RETRY *LT &MAXTRY) THEN(DO)
               GOTO       CMDLBL(START)
               ENDDO
 
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 
/* Abnormal Processing                                               */
 
 ABNOR:      IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                        CHGJOB  SWS(XXXXXX11)
                        MONMSG  MSGID(CPF0000 MCH0000)
                        DMPCLPGM
                        MONMSG  MSGID(CPF0000 MCH0000)
             ENDDO
 
             SNDPGMMSG  MSG('GLC2808 - Fontis File Acceptance Check +
                          - ABNORMAL TERMINATION') TOPGMQ(*PRV) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
