/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL A/C Pool background job Send')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/********GLCJ103*-*Midas*GL*A/C Pooling background job Send***********/   /*EML110*/
/*       XXCJ113 - Midas GL A/C Pooling background job Send          */   /*EML110*/
/*                                                                   */
/********(c)*Misys*International*Banking*Systems*Ltd.*2007************/   /*EML110*/
/*       (c) Finastra International Limited 2018                     */   /*EML110*/
/*                                                                   */
/*       Last Amend No. EML110             Date 20Jan20              */
/*       Prev Amend No. TFJ011  *CREATE    Date 23Jan07              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       EML110 - Account Balance Pooling. Upgrade to FBM 2.1        */
/*       TFJ011 - Account Pooling                                    */
/*                                                                   */
/*********************************************************************/
             PGM

             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DTAARAJ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTAARAL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNO) TYPE(*CHAR) LEN(6)
             DCL        VAR(&JOBINF) TYPE(*CHAR) LEN(26)
             DCL        VAR(&RETCOD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&FSEQ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&FNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PTYP) TYPE(*CHAR) LEN(1)

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

             CHGVAR     VAR(&DPLIB) VALUE(&SYSID *TCAT 'DPLIB')
             CHGVAR     VAR(&DMLIB) VALUE(&SYSID *TCAT 'DMLIB')

/* Create dataarea name */
             CHGVAR     VAR(&DTAARAL) VALUE('POTLDTA')

/* Lock Data area to prevent another job */
             ALCOBJ     OBJ((&DPLIB/&DTAARAL *DTAARA *EXCL)) WAIT(0)

             CHGVAR     VAR(&DTAARAJ) VALUE('POTJDTA')

/* Retrieve job information and store. */
             RTVJOBA    JOB(&JOBNAME) USER(&JOBUSER) NBR(&JOBNO)
             CHGVAR     VAR(&JOBINF) VALUE(&JOBNAME *CAT &JOBUSER +
                          *CAT &JOBNO)
             CHGDTAARA  DTAARA(&DPLIB/&DTAARAJ) VALUE(&JOBINF)

/* Call program to see if time to receive an incoming A/C pooling file */
 LOOP:
/*           CLRPFM     FILE(GLPSINPP) */ /*EML110*/
             CLRPFM     FILE(XXPSINPP) /*EML110*/
             MONMSG     MSGID(CPF0000)
/*           CLRPFM     FILE(GLPSOTPP) */ /*EML110*/
             CLRPFM     FILE(XXPSOTPP) /*EML110*/
             MONMSG     MSGID(CPF0000)
/*           CLRPFM     FILE(GLPODLPP) */ /*EML110*/
             CLRPFM     FILE(XXPODLPP) /*EML110*/
             MONMSG     MSGID(CPF0000)

             CHGVAR     VAR(&RETCOD) VALUE('       ')
/*           CALL       PGM(GLJ103) PARM(&RETCOD &DMLIB &FSEQ &FNAME) */ /*EML110*/
             CALL       PGM(XXJ113) PARM(&RETCOD &DMLIB &FSEQ &FNAME) /*EML110*/

/* If return code is 'DBASE' goto ABNOR */
             IF         COND(&RETCOD = 'DBASE') THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO

/* If return code is '*PROC' then time to process the incoming FTP file */
             IF         COND(&RETCOD = '*PROC') THEN(DO)

/* Copy details from Pooling Outgoing Details file to file name being FTPed */
/*              CPYF       FROMFILE(GLPODLPP) TOFILE(&DMLIB/&FNAME) TOMBR(&FNAME) +
                             MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK) */ /*EML110*/
                CPYF       FROMFILE(XXPODLPP) TOFILE(&DMLIB/&FNAME) TOMBR(&FNAME) +
                             MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK) +
                             /*EML110*/

/* Call program to perform the FTP process  */
             CHGVAR     VAR(&RETCOD) VALUE('       ')
/*           CALL       PGM(GLCJ104) PARM(&RETCOD 'SEND' &FSEQ &FNAME) */ /*EML110*/
             CALL       PGM(XXCJ114) PARM(&RETCOD 'SEND' &FSEQ &FNAME) /*EML110*/

/* If return code is '*Error' goto ABNOR */
             IF         COND(&RETCOD = '*Error') THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO

             ENDDO

             DLYJOB     DLY(40)
             GOTO       CMDLBL(LOOP)

             GOTO       CMDLBL(END)

 ABNOR:

              CHGJOB     SWS(XXXXXX11)

/*            SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program GLCJ103 +
                           ended abnormally - see job log') TOMSGQ(MOPERQ) */ /*EML110*/
              SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program XXCJ113 +
                           ended abnormally - see job log') TOMSGQ(MOPERQ) +
                           /*EML110*/
                MONMSG     MSGID(CPF0000 MCH0000)
              SNDBRKMSG  MSG('Account Pooling Send Background job +
                           has failed') TOMSGQ(*ALLWS)

/* END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International Banking +
                           Systems Ltd.') */ /*EML110*/
 END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited +
                           2018') /*EML110*/
              ENDPGM
