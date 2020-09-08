/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Outgoing Reconcile Data Details')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/********GLCJ108*-*Midas*GL*Outgoing Reconcile Data Details***********/  /*EML110*/
/*       XXCJ118 - Midas GL Outgoing Reconcile Data Details          */  /*EML110*/
/*                                                                   */
/********(c)*Misys*International*Banking*Systems*Ltd.*2007************/  /*EML110*/
/*       (c) Finastra International Limited 2018                     */  /*EML110*/
/*                                                                   */
/*       Last Amend No. EML110             Date 20Jan20              */
/*       Prev Amend No. TFJ011  *CREATE    Date 23Jan07              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       EML110 - Account Balance Pooling. Upgrade to FBM 2.1        */
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
                          International Banking Systems Ltd. 2007') */ /*EML110*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Limited 2018') /*EML110*/

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

/*           CLRPFM     FILE(GLPSINPP)   */ /*EML110*/
             CLRPFM     FILE(XXPSINPP) /*EML110*/
             MONMSG     MSGID(CPF0000 MCH0000)
/*           CLRPFM     FILE(GLPSOTPP)   */ /*EML110*/
             CLRPFM     FILE(XXPSOTPP) /*EML110*/
             MONMSG     MSGID(CPF0000 MCH0000)
/*           CLRPFM     FILE(GLRODLPP)   */ /*EML110*/
             CLRPFM     FILE(XXRODLPP) /*EML110*/
             MONMSG     MSGID(CPF0000 MCH0000)

/* Call Outgoing Reconcile Data Details */

             CHGVAR     VAR(&RETCOD) VALUE('       ')
             CHGVAR     VAR(&FNAME)  VALUE('          ')
/*           CALL       PGM(GLJ108) PARM(&RETCOD &DMLIB &FNAME) */ /*EML110*/
             CALL       PGM(XXJ118) PARM(&RETCOD &DMLIB &FNAME) /*EML110*/

/* If Database error then goto ABNOR */
             IF         COND(&RETCOD = 'DBASE') THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO

/* Copy details from Pooling Outgoing Details file to file name being FTPed */
/*           CPYF       FROMFILE(GLRODLPP) TOFILE(&DMLIB/&FNAME) TOMBR(&FNAME) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK) */ /*EML110*/
             CPYF       FROMFILE(XXRODLPP) TOFILE(&DMLIB/&FNAME) TOMBR(&FNAME) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK) /*EML110*/

/* Call A/C Pooling FTP */

             CHGVAR     VAR(&TTYPE)  VALUE('SEND')
             CHGVAR     VAR(&SEQNO)  VALUE('REC')
/*           CALL       PGM(GLCJ104) PARM(&RETCOD &TTYPE &SEQNO &FNAME) */ /*EML110*/
             CALL       PGM(XXCJ114) PARM(&RETCOD &TTYPE &SEQNO &FNAME) /*EML110*/


             GOTO       CMDLBL(END)

 ABNOR:

              CHGJOB     SWS(XXXXXX11)

                SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                             GLCJ108 ended abnormally - see job log') +
                             TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)

/* END:           CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International Banking +
                             Systems Ltd.') */ /*EML110*/
 END:           CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited +
                             2018') /*EML110*/

              ENDPGM
