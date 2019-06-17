/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL GCMS FTP check for accepted files - MT999')  */
/********************************************************************/
/*                                                                  */
/*   Midas - Midas-Fontis Interface                                 */
/*                                                                  */
/****GLCJ044*-**GCMS*FTP*Check*for*accepted*files*-*MT999************/                    /*JMI113*/
/*   XXC113044 - GCMS FTP Check for accepted files - MT999          */                    /*JMI113*/
/*                                                                  */
/****(C)*Copyright*Midas-Kapiti*International*Ltd.*1997**************/                    /*JMI113*/
/*   (C) Finastra International Limited 2018                        */                    /*JMI113*/
/*                                                                  */
/*   Last Amend No. JMI113             Date 23May17                 */
/*   Prev Amend No. JMI019             Date 19Dec06                 */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CGL004 *CREATE   Date 14MAR97               */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*   JMI113 - Midas GCMS Interface. Upgrade to FBM 2.1              */
/*   JMI019 - Replace GLGOINPD with GLG9INPD                        */
/*   CGL004 - Midas-Fontis Interface                                */
/*                                                                  */
/********************************************************************/

             PGM        PARM(&HOST &MAXTRY &RTCD)

/* Copyright Statement                                               */

/*           DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')         */                                               /*JMI113*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited 2018.')                          /*JMI113*/

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

/* START:      CLRPFM     FILE(GLGOLSPD)                             */                   /*JMI113*/
 START:      CLRPFM     FILE(XXGOLSPD)                                                    /*JMI113*/

/* Override default input and output files                           */

/*           OVRDBF     FILE(INPUT) TOFILE(GLGOINPD)                                        JMI019*/
/*           OVRDBF     FILE(INPUT) TOFILE(GLG9INPD)                 */       /*JMI019*/  /*JMI113*/
/*           OVRDBF     FILE(OUTPUT) TOFILE(GLGOLSPD)                */                   /*JMI113*/
             OVRDBF     FILE(INPUT) TOFILE(XXG9INPD)                                      /*JMI113*/
             OVRDBF     FILE(OUTPUT) TOFILE(XXGOLSPD)                                     /*JMI113*/

/* Start TCP function                                                */

             STRTCPFTP  RMTSYS(&HOST)

/* Call GL2808 to analyse the outptut file                           */

/*           CALL       PGM(GLJ004) PARM(&HOST &MAXTRY &RTCD)        */                   /*JMI113*/
             CALL       PGM(XX113004) PARM(&HOST &MAXTRY &RTCD)                           /*JMI113*/

/* Delete file overrides                                             */

             DLTOVR     FILE(*ALL)

/* Check for error messages                                         */
/* If job switches 7 or 8 are on, perform abnormal processing       */

             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             SNDPGMMSG  MSG('GCMS FTP Acceptance Check ended +
                          abnormally') TOPGMQ(*PRV) TOMSGQ(MRUNQ +
                          MOPERQ)
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

/*           SNDPGMMSG  MSG('GLCJ004 - GCMS File Acceptance Check +
                          - ABNORMAL TERMINATION') TOPGMQ(*PRV) +
                          TOMSGQ(MOPERQ MRUNQ)                       */                   /*JMI113*/
             SNDPGMMSG  MSG('XXC113004 - GCMS File Acceptance Check +
                          - ABNORMAL TERMINATION') TOPGMQ(*PRV) +
                          TOMSGQ(MOPERQ MRUNQ) /*JMI113*/
             MONMSG     MSGID(CPF0000 MCH0000)

 END:        ENDPGM
