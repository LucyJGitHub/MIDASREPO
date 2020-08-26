/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Outgoing Reconcile Data Details')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/********GLCJ108*-*Midas*GL*Outgoing Reconcile Data Details***********/  /*JMI108*/
/*       XXCJ118 - Midas GL Outgoing Reconcile Data Details          */  /*JMI108*/
/*                                                                   */
/********(c)*Misys*International*Banking*Systems*Ltd.*2007************/  /*JMI108*/
/*       (c) Finastra International Limited 2018                     */  /*JMI108*/
/*                                                                   */
/*       Last Amend No. FIX999             Date 24Aug20              */
/*       Prev Amend No. JMI108             Date 31May18              */
/*                      TFJ011  *CREATE    Date 23Jan07              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       FIX999 - IDNOTRECP contains previous dates eg 14Aug,18Aug,  */
/*                19Aug. Shld only reflect 19Aug20.                  */
/*       JMI108 - Account Balance Pooling. Upgrade to FBM 2.1        */
/*       TFJ011 - Account Balance Pooling                            */
/*                                                                   */
/*********************************************************************/
             PGM

             DCL        VAR(&SYSID)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&DMLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&RETCOD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&FNAME)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TTYPE)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&SEQNO)  TYPE(*CHAR) LEN(3)
/*           DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Misys +
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

/* Clear files */

/*           CLRPFM     FILE(GLPSINPP)   */ /*JMI108*/
             CLRPFM     FILE(XXPSINPP) /*JMI108*/
             MONMSG     MSGID(CPF0000 MCH0000)
/*           CLRPFM     FILE(GLPSOTPP)   */ /*JMI108*/
             CLRPFM     FILE(GLPSOTPP) /*JMI108*/
             MONMSG     MSGID(CPF0000 MCH0000)
/*           CLRPFM     FILE(GLRODLPP)   */ /*JMI108*/
/*****       CLRPFM     FILE(GLRODLPP)  *JMI108*        *******/ /*FIX999*/
             CLRPFM     FILE(XXRODLPP) /*FIX999*/
             MONMSG     MSGID(CPF0000 MCH0000)

/* Call Outgoing Reconcile Data Details */

             CHGVAR     VAR(&RETCOD) VALUE('       ')
             CHGVAR     VAR(&FNAME)  VALUE('          ')
/*           CALL       PGM(GLJ108) PARM(&RETCOD &DMLIB &FNAME) */ /*JMI108*/
             CALL       PGM(XXJ118) PARM(&RETCOD &DMLIB &FNAME) /*JMI108*/

/* If Database error then goto ABNOR */
             IF         COND(&RETCOD = 'DBASE') THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO

/* Copy details from Pooling Outgoing Details file to file name being FTPed */
/*           CPYF       FROMFILE(GLRODLPP) TOFILE(&DMLIB/&FNAME) TOMBR(&FNAME) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK) */ /*JMI108*/
             CPYF       FROMFILE(XXRODLPP) TOFILE(&DMLIB/&FNAME) TOMBR(&FNAME) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK) /*JMI108*/

/* Call A/C Pooling FTP */

             CHGVAR     VAR(&TTYPE)  VALUE('SEND')
             CHGVAR     VAR(&SEQNO)  VALUE('REC')
/*           CALL       PGM(GLCJ104) PARM(&RETCOD &TTYPE &SEQNO &FNAME) */ /*JMI108*/
             CALL       PGM(XXCJ114) PARM(&RETCOD &TTYPE &SEQNO &FNAME) /*JMI108*/


             GOTO       CMDLBL(END)

 ABNOR:

              CHGJOB     SWS(XXXXXX11)

                SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                             GLCJ108 ended abnormally - see job log') +
                             TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)

/* END:           CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International Banking +
                             Systems Ltd.') */ /*JMI108*/
 END:           CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited +
                             2018') /*JMI108*/

              ENDPGM
