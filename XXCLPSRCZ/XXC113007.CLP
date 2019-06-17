/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL GCMS File Transfer process check')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Midas-GCMS Interface                                */
/*                                                                   */
/********GLCJ007*-*TCP/IP*FTP*TRANSMISSION****************************/                   /*JMI113*/
/*       XXC113007 - TCP/IP FTP Transmission                         */                   /*JMI113*/
/*                                                                   */
/*       Function : This program performs the FTP Transmission       */
/*                  to a remote machine and checks the result of     */
/*                  connection between the two systems.              */
/*                                                                   */
/********Calls*:*GLJ007*-*GCMS*File*Transfer*Process*Check************/                   /*JMI113*/
/*       Calls : XX113007 - GCMS File Transfer Process Check         */                   /*JMI113*/
/*                                                                   */
/********(c) Misys International Banking Systems Ltd. 2007           */                   /*JMI113*/
/*       (c) Finastra International Limited 2018                     */                   /*JMI113*/
/*                                                                   */
/*       Last Amend No. JMI113             Date 22May18              */
/*       Prev Amend No. JMI019             Date 06Sep07              */
/*                      JMI019  *CREATE    Date 21Feb07              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       JMI118 - Midas GCMS Interface. Upgrade to FBM 2.1           */
/*       JMI019 - Additional codes to upgrade                        */
/*       JMI019 - Upgrade as is                                      */
/*       JMI019 - Midas-GCMS Interface                               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&HOST &MAXTRY &RTCD)

/**  Copyright statement definition                                */

/*           DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) +
                          VALUE('''(c) Misys International Banking +
                          Systems Ltd. 2007')    */                                       /*JMI113*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) +
                          VALUE('''(c) Finastra International Limit+
                          ed 2018')                                                       /*JMI113*/

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
/***Backup*log*file*GLG94OPD*to*GLGOOTBK*before*it*is*cleared*******/          /*JMI019*/ /*JMI113*/
/** Backup log file XXG94OPD to XXGOOTBK before it is cleared      */                     /*JMI113*/
/** Clear Output File                                              */
/*           CLRPFM     FILE(GLGOOTPD)                               JMI019*/
/*           CPYF       FROMFILE(GLG94OPD) TOFILE(GLGOOTBK) +
                          MBROPT(*ADD)                    */       /*JMI019*/             /*JMI113*/
             CPYF       FROMFILE(XXG94OPD) TOFILE(XXGOOTBK) +
                          MBROPT(*ADD)                                                    /*JMI113*/
/*           CLRPFM     FILE(GLG94OPD)               */            /*JMI019*/
             CLRPFM     FILE(XXG94OPD)                                                    /*JMI113*/

/** Override FTP files  INPUT & OUTPUT                             */

/*           OVRDBF     FILE(INPUT)  TOFILE(GLGOINPD)                JMI019*/
/*           OVRDBF     FILE(OUTPUT) TOFILE(GLGOOTPD)                JMI019*/
/*           OVRDBF     FILE(INPUT)  TOFILE(GLG94IPD)         */   /*JMI019*/             /*JMI113*/
/*           OVRDBF     FILE(OUTPUT) TOFILE(GLG94OPD)         */   /*JMI019*/             /*JMI113*/
             OVRDBF     FILE(INPUT)  TOFILE(XXG94IPD)                                     /*JMI113*/
             OVRDBF     FILE(OUTPUT) TOFILE(XXG94OPD)                                     /*JMI113*/

/** Start TCP/IP FTP function                                      */
             STRTCPFTP  RMTSYS(&HOST)

/** Read the FTP Output file                                       */

             CHGVAR     VAR(&MODE) VALUE('SEND')
             CHGVAR     VAR(&RTCD) VALUE(' ')
/*           CALL       PGM(GLJ007) PARM(&MODE &RTCD)              */                     /*JMI113*/
             CALL       PGM(XX113007) PARM(&MODE &RTCD) /*JMI113*/
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

/*           SNDPGMMSG  MSG('GLCJ007 - GCMS File Transfer Protocol +
                          Functions - ABNORMAL TERMINATION') +
                          TOPGMQ(*PRV) TOMSGQ(MOPERQ MRUNQ)      */                       /*JMI113*/
           SNDPGMMSG  MSG('XXC113007 - GCMS File Transfer Protocol +
                          Functions - ABNORMAL TERMINATION') +
                          TOPGMQ(*PRV) TOMSGQ(MOPERQ MRUNQ)                               /*JMI113*/
             MONMSG     MSGID(CPF0000 MCH0000)

/** End of program                                                 */

 END:        ENDPGM

