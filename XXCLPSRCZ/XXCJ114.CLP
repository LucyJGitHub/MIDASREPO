/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL A/C Pooling FTP')                            */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger                                      */
/*                                                                   */
/********GLCJ104*-*Midas*GL*A/C Pooling FTP***************************/ /*JMI108*/
/*       XXCJ114 - Midas GL A/C Pooling FTP                          */ /*JMI108*/
/*                                                                   */
/********(c)*Misys*International*Banking*Systems*Ltd.*2007************/ /*JMI108*/
/*       (c) Finastra International Limited 2018                     */ /*JMI108*/
/*                                                                   */
/*       Last Amend No. JMI108             Date 31May18              */
/*       Prev Amend No. TFJ011  *CREATE    Date 23Jan07              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       JMI108 - Account Balance Pooling. Upgrade to FBM 2.1        */
/*       TFJ011 - Account Pooling                                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RETCOD &MODE &FSEQ &FNAM)

             DCL        VAR(&RETCOD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&RETRN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MODE2) TYPE(*CHAR) LEN(7)
             DCL        VAR(&FSEQ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&FNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&HOST) TYPE(*CHAR) LEN(15)
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ENT) TYPE(*CHAR) LEN(3)
/*           DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Misys +
                          International Banking Systems Ltd. 2007') */ /*JMI108*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Limited 2018') /*JMI108*/

             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(&DPLIB) VALUE(&SYSID *CAT 'DPLIB   ')

/*  Get IP address of server */
/*           RTVDTAARA  DTAARA(SDPFTPDA (1 15)) RTNVAR(&HOST) */ /*JMI108*/
             RTVDTAARA  DTAARA(XXPFTPDA (1 15)) RTNVAR(&HOST) /*JMI108*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/* Create local data area */

             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local data area') AUT(*ALL)
             MONMSG     MSGID(CPF1023)

             CHGDTAARA  DTAARA(LDA) VALUE(' ')

             CHGJOB     SWS(XXXXXX00)

/* Main processing */
/* Override FTP files  INPUT & OUTPUT                             */
             IF         COND(&MODE = 'SEND') THEN(DO)
/*           OVRDBF     FILE(INPUT)  TOFILE(GLPSINPP) */ /*JMI108*/
/*           OVRDBF     FILE(OUTPUT) TOFILE(GLPSOTPP) */ /*JMI108*/
                OVRDBF     FILE(INPUT)  TOFILE(XXPSINPP) /*JMI108*/
                OVRDBF     FILE(OUTPUT) TOFILE(XXPSOTPP) /*JMI108*/
             ENDDO

             IF         COND(&MODE = 'REC') THEN(DO)
/*           OVRDBF     FILE(INPUT)  TOFILE(GLPRINPP) */ /*JMI108*/
/*           OVRDBF     FILE(OUTPUT) TOFILE(GLPROTPP) */ /*JMI108*/
                OVRDBF     FILE(INPUT)  TOFILE(XXPRINPP)
                OVRDBF     FILE(OUTPUT) TOFILE(XXPROTPP)
             ENDDO

             IF         COND(&MODE = 'MANUALS' *OR &MODE = +
                          'MANUALR') THEN(DO)
/*           OVRDBF     FILE(INPUT)  TOFILE(GLPMINPP) */ /*JMI108*/
/*           OVRDBF     FILE(OUTPUT) TOFILE(GLPMOTPP) */ /*JMI108*/
                OVRDBF     FILE(INPUT)  TOFILE(XXPMINPP) /*JMI108*/
                OVRDBF     FILE(OUTPUT) TOFILE(XXPMOTPP) /*JMI108*/
             ENDDO

/* Start TCP/IP FTP function                                      */
             STRTCPFTP  RMTSYS(&HOST)

/* Read the FTP Output file                                       */

             CHGVAR     VAR(&RTCD) VALUE(' ')
/*           CALL       PGM(GLJ104) PARM(&RETCOD &MODE &FSEQ) */ /*JMI108*/
             CALL       PGM(XXJ114) PARM(&RETCOD &MODE &FSEQ) /*JMI108*/
             DLTOVR     FILE(*ALL)

             IF         COND(&RETCOD *EQ '       ') THEN(DO)

/**Copy*details*from*file*FTPed*to input file for use in GLJ106**/ /*JMI108*/
/* Copy details from file FTPed to input file for use in XXJ116 */ /*JMI108*/
             IF         COND(&MODE = 'REC' *OR &MODE = +
                          'MANUALR') THEN(DO)
/*              CPYF       FROMFILE(&FNAM) TOFILE(&DPLIB/GLPIDLPP) +
                             MBROPT(*REPLACE) FMTOPT(*NOCHK) */ /*JMI108*/
                CPYF       FROMFILE(&FNAM) TOFILE(&DPLIB/XXPIDLPP) +
                             MBROPT(*REPLACE) FMTOPT(*NOCHK) /*JMI108*/
             ENDDO

             GOTO       CMDLBL(END)
             ENDDO

             IF         COND(&RETCOD *EQ '*Error') THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO

/** FTP failure, send message to MOPERQ and print FTP details error report */
/*           CALL       PGM(GLJ104P) PARM(&RETRN &SEQ &LEV &ENT &MODE) */ /*JMI108*/
             CALL       PGM(XXJ114P) PARM(&RETRN &SEQ &LEV &ENT &MODE) /*JMI108*/

/** If the FTP operation failed due to an incorrect remote user id */
/** and password combination - send a message to the user and      */
/** goto END (do not want to go to ABNOR as want job to keep running) */

             IF         COND(&RETCOD *EQ 'LOGIN') THEN(DO)
               SNDPGMMSG  MSG('Login Failed - Check Userid/Password') +
               TOPGMQ(*PRV) TOMSGQ(MRUNQ MOPERQ)
             GOTO       CMDLBL(END)
             ENDDO

/** If the FTP operation failed due to the link being down */
/** send a message to the user and goto END (do not want to go to ABNOR  */
/** as want job to keep running)                           */

             IF         COND(&RETCOD *EQ 'FAILED') THEN(DO)
               SNDPGMMSG  MSG('Login Failed - Link down') +
               TOPGMQ(*PRV) TOMSGQ(MRUNQ MOPERQ)
             GOTO       CMDLBL(END)
             ENDDO

/** If the FTP operation failed due to database error */
/** send a message to the user and goto END (do not want to go to ABNOR  */
/** as want job to keep running)                           */

             IF         COND(&RETCOD *EQ 'DBASE') THEN(DO)
               SNDPGMMSG  MSG('FTP Failed - Database') +
               TOPGMQ(*PRV) TOMSGQ(MRUNQ MOPERQ)
             GOTO       CMDLBL(END)
             ENDDO

/** If the FTP operation failed due to command error */
/** send a message to the user and goto END (do not want to go to ABNOR  */
/** as want job to keep running)                           */

             IF         COND(&RETCOD *EQ 'COMMAND') THEN(DO)
               SNDPGMMSG  MSG('FTP Failed - Command error') +
               TOPGMQ(*PRV) TOMSGQ(MRUNQ MOPERQ)
             GOTO       CMDLBL(END)
             ENDDO

 ABNOR:
             CHGJOB     SWS(XXXXXX11)

/*           SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program GLCJ104 ended +
                          abnormally - see job log') TOMSGQ(MOPERQ) */ /*JMI108*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program XXCJ114 ended +
                          abnormally - see job log') TOMSGQ(MOPERQ) /*JMI108*/
               MONMSG     MSGID(CPF0000 MCH0000)

/* END:          CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International Banking +
                            Systems Ltd.') */ /*JMI108*/
 END:          CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited +
                            2018') /*JMI108*/

             ENDPGM
