/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('G-AML FTP Processing')                                */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/********SCCJ003*-*G-AML*FTP*Processing*******************************/
/*       XXC109010 - G-AML FTP Processing                            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2008           */
/*                                                                   */
/*       Last Amend No. JMI109             Date 23May18              */
/*       Prev Amend No. JMI026             Date 29Sep08              */
/*                      JMI026   *CREATE   Date 30Apr08              */
/*********************************************************************/
/*                                                                   */
/*       JMI109 - G-AML PreProcessor (Upgrade to FB Midas)           */
/*       JMI026 - Changed entry parameter sequence                   */
/*       JMI026 - G-AML PreProcessor                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RETRN &WDATA)
/**********  PGM        PARM(&WDATA &RETRN) */                                            /*JMI026*/

/* Copyright Statement                                               */

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2008')

/* Declare Variables                                                 */

             DCL        VAR(&SYSID) TYPE(*CHAR)  LEN(2)
             DCL        VAR(&DPLIB) TYPE(*CHAR)  LEN(7)
             DCL        VAR(&HOST) TYPE(*CHAR)  LEN(15)
             DCL        VAR(&WDATA) TYPE(*CHAR)  LEN(100)
             DCL        VAR(&RETRN) TYPE(*CHAR)  LEN(7)
             DCL        VAR(&SEQ) TYPE(*CHAR)  LEN(5)

/* Global Message Monitor                                            */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/* Create Data Area in QTEMP                                         */

             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)

/* Set off all user job switches                                     */

             CHGJOB     SWS(00000000)

             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(&DPLIB) VALUE(&SYSID *CAT 'DPLIB')

/* Clear files                                                       */

/*           CLRPFM     FILE(SCFTPIPP)  */                                                /*JMI109*/
/*           CLRPFM     FILE(SCFTPOPP)  */                                                /*JMI109*/
             CLRPFM     FILE(XXFTPIPD)                                                    /*JMI109*/
             CLRPFM     FILE(XXFTPOPD)                                                    /*JMI109*/

/* Call SCJ00001 to output extract files into the compacted formats */

/*           CALL       PGM(SCJ00001)   */

/**Call*SCJ00002*to*create*FTP*commands**/                                                /*JMI109*/
/* Call XX109011 to create FTP commands */                                                /*JMI109*/

/*           CALL       PGM(SCJ00002) PARM(&WDATA &DPLIB &HOST)      */                   /*JMI109*/
             CALL       PGM(XX109011) PARM(&WDATA &DPLIB &HOST)                           /*JMI109*/

/* Override default input and output files                           */

/*           OVRDBF     FILE(INPUT) TOFILE(SCFTPIPP)                 */                   /*JMI109*/
/*           OVRDBF     FILE(OUTPUT) TOFILE(SCFTPOPP)                */                   /*JMI109*/
             OVRDBF     FILE(INPUT) TOFILE(XXFTPIPD)                                      /*JMI109*/
             OVRDBF     FILE(OUTPUT) TOFILE(XXFTPOPD)                                     /*JMI109*/

/* Start TCP function                                                */

             STRTCPFTP RMTSYS(&HOST)

/* If job switches 7 or 8 are on, perform abnormal processing       */

             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             SNDPGMMSG  MSG('G-AML FTP Processing ended +
                          abnormally') TOPGMQ(*PRV) TOMSGQ(MRUNQ +
                          MOPERQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO

/**Call*SCJ00003*to*generate*report******/                                                /*JMI109*/
/* Call XX109012 to generate report     */                                                /*JMI109*/

/*           CALL       PGM(SCJ00003) PARM(&RETRN &SEQ)   */                              /*JMI109*/
             CALL       PGM(XX109012) PARM(&RETRN &SEQ)                                   /*JMI109*/

/* Delete File Overrides */

             DLTOVR     FILE(*ALL)

/**Call*SCJ00004*to*check*FTP*results****/                                                /*JMI109*/
/* Call XX109013 to check FTP results   */                                                /*JMI109*/

/*           CALL       PGM(SCJ00004) PARM(&RETRN)         */                             /*JMI109*/
             CALL       PGM(XX109013) PARM(&RETRN)                                        /*JMI109*/

             IF         COND(&RETRN *EQ ' ') THEN(DO)
             GOTO       CMDLBL(END)
             ENDDO

             IF         COND(&RETRN *NE ' ') THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO

/* Abnormal Processing                                               */

 ABNOR:      CHGJOB     SWS(XXXXXX11)

             IF         COND(&RETRN = 'LOGIN') THEN(DO)

             SNDPGMMSG  MSG('LOGIN Failed - Check UserId/Password') +
                          TOPGMQ(*PRV) TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)

            ENDDO

             IF         COND(&RETRN = 'FAILED') THEN(DO)

             SNDPGMMSG  MSG('LOGIN Failed - Link Down') +
                          TOPGMQ(*PRV) TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)

            ENDDO

             IF         COND(&RETRN = 'DBASE') THEN(DO)

             SNDPGMMSG  MSG('FTP Failed - Database') +
                          TOPGMQ(*PRV) TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)

            ENDDO

             IF         COND(&RETRN = 'COMMAND') THEN(DO)

             SNDPGMMSG  MSG('FTP Failed - Command Error') +
                          TOPGMQ(*PRV) TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)

            ENDDO

             IF         COND(&RETRN = '*Error') THEN(DO)

             SNDPGMMSG  MSG('FTP Processing Ended Abnormally') +
                          TOPGMQ(*PRV) TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)

            ENDDO

                        DMPCLPGM

 END:        ENDPGM
