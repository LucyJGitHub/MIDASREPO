/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL A/C Pool background job Receive')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/********GLCJ102*-*Midas*GL A/C Pooling background job Receive********/         /*EML110*/
/*       XXCJ112 - Midas GL A/C Pooling background job Receive       */         /*EML110*/
/*                                                                   */
/********(c)*Misys*International*Banking*Systems*Ltd.*2007************/         /*EML110*/
/*       (c) Finastra International Limited 2018                     */         /*EML110*/
/*                                                                   */
/*       Last Amend No. EML110             Date 20Jan20              */
/*       Prev Amend No. TFJ11A             Date 23Jan07              */
/*                      TFJ011  (CHG141)   Date 31Aug05              */
/*                      TFJ011  (CHG014)   Date 26Aug05              */
/*                              *CREATE    Date 15Mar05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       EML110 - Account Balance Pooling. Upgrade to FBM 2.1        */
/*       TFJ11A - Account Transfer Service                           */
/*       TFJ011 - (CHG141) Further Requirements by the Bank          */
/*       TFJ011 - (CHG014) Create a Data Error Report                */
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
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE('       ')                    /*CHG014*/
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
             CHGVAR     VAR(&DTAARAL) VALUE('PINLDTA')

/* Lock Data area to prevent another job */
             ALCOBJ     OBJ((&DPLIB/&DTAARAL *DTAARA *EXCL)) WAIT(0)

             CHGVAR     VAR(&DTAARAJ) VALUE('PINJDTA')

/* Retrieve job information and store. */
             RTVJOBA    JOB(&JOBNAME) USER(&JOBUSER) NBR(&JOBNO)
             CHGVAR     VAR(&JOBINF) VALUE(&JOBNAME *CAT &JOBUSER +
                          *CAT &JOBNO)
             CHGDTAARA  DTAARA(&DPLIB/&DTAARAJ) VALUE(&JOBINF)

/* Call program to see if time to receive an incoming A/C pooling file */
 LOOP:
/*           CLRPFM     FILE(GLPRINPP) */ /*EML110*/
             CLRPFM     FILE(XXPRINPP) /*EML110*/
             MONMSG     MSGID(CPF0000)
/*           CLRPFM     FILE(GLPROTPP) */ /*EML110*/
             CLRPFM     FILE(XXPROTPP) /*EML110*/
             MONMSG     MSGID(CPF0000)

             CHGVAR     VAR(&RETCOD) VALUE('       ')
/*           CALL       PGM(GLJ102) PARM(&RETCOD &DMLIB &FSEQ &FNAME) */ /*EML110*/
             CALL       PGM(XXJ112) PARM(&RETCOD &DMLIB &FSEQ &FNAME) /*EML110*/

/* If return code is '*PROC' then time to process the incoming FTP file */
             IF         COND(&RETCOD = '*PROC') THEN(DO)

/* Call program to perform the FTP process  */
             CHGVAR     VAR(&RETCOD) VALUE('       ')
/*           CALL       PGM(GLCJ104) PARM(&RETCOD 'REC' &FSEQ &FNAME) */ /*EML110*/
             CALL       PGM(XXCJ114) PARM(&RETCOD 'REC' &FSEQ &FNAME) /*EML110*/

/* If return code is '*Error' goto ABNOR */
             IF         COND(&RETCOD = '*Error') THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO

/* If return code is *BLANKS then processing of the incoming FTP file */
/* was successful */
             IF         COND(&RETCOD = '       ') THEN(DO)

/* Copy file received to Pooling Incoming details processing file */
/*              CPYF       FROMFILE(&FNAME) TOFILE(&DPLIB/GLPIDLPP) +
                             TOMBR(GLPIDLPP) MBROPT(*REPLACE) FMTOPT(*NOCHK) */ /*EML110*/
                CPYF       FROMFILE(&FNAME) TOFILE(&DPLIB/XXPIDLPP) +
                             TOMBR(XXPIDLPP) MBROPT(*REPLACE) FMTOPT(*NOCHK) +
                             /*EML110*/

/* Call program to process the details received on incoming file */
             CHGVAR     VAR(&RETCOD) VALUE('       ')
   LOOP1:
             ALCOBJ     OBJ((GLJEIPPD *FILE *EXCL))
/* Unable to allocate, DLY and keep trying */
             MONMSG     MSGID(CPF0000) EXEC(DO)
             DLYJOB     DLY(15)
             GOTO       LOOP1
             ENDDO

             ALCOBJ     OBJ((GLJEIHPD *FILE *EXCL))                                       /*TFJ11A*/
/* Unable to allocate, DLY and keep trying */                                             /*TFJ11A*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                                           /*TFJ11A*/
             DLYJOB     DLY(15)                                                           /*TFJ11A*/
             GOTO       LOOP1                                                             /*TFJ11A*/
             ENDDO                                                                        /*TFJ11A*/
                                                                                          /*TFJ11A*/
             STRCMTCTL  LCKLVL(*ALL)
             MONMSG     MSGID(CPF0000)

/**********  CALL       PGM(GLCJ113) PARM(&RTCD ' ' ' ' ' ') */                /*CHG014*/ /*CHG141*/
/*           CALL       PGM(GLCJ113) PARM(&RTCD ' ' ' ' ' ' &FSEQ) */ /*CHG141*/ /*EML110*/
             CALL       PGM(XXCJ123) PARM(&RTCD ' ' ' ' ' ' &FSEQ) /*EML110*/
                                                                                          /*CHG014*/
/* If return code is '*Error' goto ABNOR */                                               /*CHG014*/
             IF         COND(&RTCD = '*ERROR') THEN(DO)                                   /*CHG014*/
             GOTO       CMDLBL(ABNOR)                                                     /*CHG014*/
             ENDDO                                                                        /*CHG014*/
                                                                                          /*CHG014*/
/*           CALL       PGM(GLJ106) PARM(&RETCOD &PTYP &FSEQ) */ /*EML110*/
             CALL       PGM(XXJ116) PARM(&RETCOD &PTYP &FSEQ) /*EML110*/
             ENDCMTCTL
             MONMSG     MSGID(CPF0000)

             DLCOBJ     OBJ((GLJEIPPD *FILE *EXCL))
             MONMSG     MSGID(CPF0000)

             DLCOBJ     OBJ((GLJEIHPD *FILE *EXCL))                                       /*TFJ11A*/
             MONMSG     MSGID(CPF0000)                                                    /*TFJ11A*/
                                                                                          /*TFJ11A*/
             IF         COND(&RETCOD = '*Error') THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO

/* If processing type is 'P' then produce Pooling details report  */
             IF         COND(&PTYP = 'P') THEN(DO)
/*              CALL       PGM(GLCJ110) PARM(&FSEQ ' ' ' ' ' ') */ /*EML110*/
                CALL       PGM(XXCJ120) PARM(&FSEQ ' ' ' ' ' ') /*EML110*/
             ENDDO

/* If processing type is 'S' then produce Sweep details report    */
             IF         COND(&PTYP = 'S') THEN(DO)
/*              CALL       PGM(GLCJ111) PARM(&FSEQ ' ' ' ' ' ') */ /*EML110*/
                CALL       PGM(XXCJ121) PARM(&FSEQ ' ' ' ' ' ') /*EML110*/
             ENDDO

             ENDDO

             ENDDO

             DLYJOB     DLY(40)
             GOTO       CMDLBL(LOOP)

             GOTO       CMDLBL(END)

 ABNOR:

              CHGJOB     SWS(XXXXXX11)

/*            SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program GLCJ102 +
                           ended abnormally - see job log') TOMSGQ(MOPERQ) */ /*EML110*/
              SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program XXCJ112 +
                           ended abnormally - see job log') TOMSGQ(MOPERQ) +
                           /*EML110*/
                MONMSG     MSGID(CPF0000 MCH0000)
             SNDBRKMSG  MSG('Account Pooling Receive Background job +
                          has failed') TOMSGQ(*ALLWS)

/* END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International Banking +
                          Systems Ltd.') */ /*EML110*/
 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited +
                          2018') /*EML110*/

              ENDPGM
