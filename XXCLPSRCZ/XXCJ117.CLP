/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL A/C Pool COB Send')                          */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/********GLCJ107*-*Midas*GL*A/C Pooling COB Send**********************/ /*JMI108*/
/*       XXCJ117 - Midas GL A/C Pooling COB Send                     */ /*JMI108*/
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
/*       TFJ011 - Account Pooling                                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CSEQ)

             DCL        VAR(&CSEQ)   TYPE(*CHAR) LEN(5)
             DCL        VAR(&SYSID)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&DMLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&RETCOD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&FNAME)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&FSEQ)   TYPE(*CHAR) LEN(3)

/*             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Misys +
                         International Banking Systems Ltd. 2007') */ /*JMI108*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Limited 2018') /*JMI108*/

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/* Create local data area */

             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local data area') AUT(*ALL)
             MONMSG     MSGID(CPF1023)


/* Create Working Data area if required */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)

             CHGVAR     VAR(&DMLIB) VALUE(&SYSID *TCAT 'DMLIB')

/*           CLRPFM     FILE(GLPSINPP) */ /*JMI108*/
             CLRPFM     FILE(XXPSINPP) /*JMI108*/
             MONMSG     MSGID(CPF0000)
/*           CLRPFM     FILE(GLPSOTPP) */ /*JMI108*/
             CLRPFM     FILE(XXPSOTPP) /*JMI108*/
             MONMSG     MSGID(CPF0000)
/*           CLRPFM     FILE(GLPODLPP) */ /*JMI108*/
             CLRPFM     FILE(XXPODLPP) /*JMI108*/
             MONMSG     MSGID(CPF0000)

/* If being called at the start of COB, clear Pooling Status file */
             IF         COND(&CSEQ = '00001') THEN(DO)
/*              CLRPFM     FILE(SDPSTSPP) */ /*JMI108*/
                CLRPFM     FILE(XXPSTSPP) /*JMI108*/
             MONMSG     MSGID(CPF0000)
             ENDDO

             CHGVAR     VAR(&RETCOD) VALUE('       ')
/*           CALL       PGM(GLJ107) PARM(&RETCOD &CSEQ &DMLIB &FNAME) */ /*JMI108*/
             CALL       PGM(XXJ117) PARM(&RETCOD &CSEQ &DMLIB &FNAME) /*JMI108*/

/* If Database error then goto ABNOR */
             IF         COND(&RETCOD = 'DBASE') THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO

/* Copy details from Pooling Outgoing Details file to file name being FTPed */
/*           CPYF       FROMFILE(GLPODLPP) TOFILE(&DMLIB/&FNAME) TOMBR(&FNAME) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK) */ /*JMI108*/
             CPYF       FROMFILE(XXPODLPP) TOFILE(&DMLIB/&FNAME) TOMBR(&FNAME) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK) /*JMI108*/

/* If being called at start of COB, file sequence is 'FID' */
             IF         COND(&CSEQ = '00001') THEN(DO)
             CHGVAR     VAR(&FSEQ) VALUE('FID')
             ENDDO

/* If being called at end of COB, file sequence is 'COB' */
             IF         COND(&CSEQ = '00002') THEN(DO)
             CHGVAR     VAR(&FSEQ) VALUE('COB')
             ENDDO

/* Call program to perform the FTP process  */
             CHGVAR     VAR(&RETCOD) VALUE('       ')
/*           CALL       PGM(GLCJ104) PARM(&RETCOD 'SEND' &FSEQ &FNAME) */ /*JMI108*/
             CALL       PGM(XXCJ114) PARM(&RETCOD 'SEND' &FSEQ &FNAME) /*JMI108*/

             GOTO       CMDLBL(END)

 ABNOR:

              CHGJOB     SWS(XXXXXX11)

/*            SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program GLCJ107 +
                           ended abnormally - see job log') TOMSGQ(MOPERQ) */ /*JMI108*/
              SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program XXCJ117 +
                           ended abnormally - see job log') TOMSGQ(MOPERQ) +
                           /*JMI108*/
                MONMSG     MSGID(CPF0000 MCH0000)

/* END:           CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys +
                             International Banking Systems Ltd.') */ /*JMI108*/
 END:           CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited +
                             2018') /*JMI108*/

              ENDPGM
