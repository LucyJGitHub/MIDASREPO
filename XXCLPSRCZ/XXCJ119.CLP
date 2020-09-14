/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL A/C Pool history processing')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/********GLCJ109*-*Midas*GL*A/C*Pooling History Processing************/ /*EML110*/
/*       XXCJ119 - Midas GL A/C Pooling History Processing           */
/*                                                                   */
/********(c)*Misys*International*Banking*Systems*Ltd.*2007************/ /*EML110*/
/*       (c) Finastra International Limited 2018                     */ /*EML110*/
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
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DAY) TYPE(*CHAR) LEN(3)
             DCL        VAR(&SEQ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&NUM) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&FILE7) TYPE(*CHAR) LEN(7)
             DCL        VAR(&FILE10) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE10B) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(5)

/*           DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Misys +
                          International Banking Systems Ltd. 2007') */ /*EML110*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Limited 2018')

/*           DCLF       FILE(SDPICDPP) */ /*EML110*/
             DCLF       FILE(XXPICDPP) /*EML110*/

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

/* Obtain todays day */
             CALL       PGM(UTJ101) PARM(&RTN &DAY)

             IF         COND(&RTN *EQ 'DBASE') THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO
/* Obtain file names from Pooling ICD file   */
             RCVF

/* Delete all files from previous week created this day */
/* and then copy today's files */

/* Reconciliation file */
             CHGVAR     VAR(&FILE7) VALUE('APRC' *CAT &DAY)
             DLTF       FILE(&FILE7)
             MONMSG     MSGID(CPF0000 MCH0000)

             CPYF       FROMFILE(&JOTREC) TOFILE(&DMLIB/&FILE7) +
                          TOMBR(&FILE7) MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817)

             DLTF       FILE(&JOPREC)
             MONMSG     MSGID(CPF0000 MCH0000)

             CPYF       FROMFILE(&JOTREC) TOFILE(&DMLIB/&JOPREC) +
                          TOMBR(&JOPREC) MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817)

/* Final intra day A/C balance file */
             CHGVAR     VAR(&FILE7) VALUE('APBL' *CAT &DAY)
             CHGVAR     VAR(&FILE10) VALUE(&FILE7 *CAT '999')
             DLTF       FILE(&FILE10)
             MONMSG     MSGID(CPF0000 MCH0000)

             CPYF       FROMFILE(&JOTFAB) TOFILE(&DMLIB/&FILE10) +
                          TOMBR(&FILE10) MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817)

             DLTF       FILE(&JOPFAB)
             MONMSG     MSGID(CPF0000 MCH0000)

             CPYF       FROMFILE(&JOTFAB) TOFILE(&DMLIB/&JOPFAB) +
                          TOMBR(&JOPFAB) MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817)

/* COB A/C balance file */
             CHGVAR     VAR(&FILE7) VALUE('APBL' *CAT &DAY)
             CHGVAR     VAR(&FILE10) VALUE(&FILE7 *CAT 'COB')
             DLTF       FILE(&FILE10)
             MONMSG     MSGID(CPF0000 MCH0000)

             CPYF       FROMFILE(&JOTCAB) TOFILE(&DMLIB/&FILE10) +
                          TOMBR(&FILE10) MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817)

             DLTF       FILE(&JOPCAB)
             MONMSG     MSGID(CPF0000 MCH0000)

             CPYF       FROMFILE(&JOTCAB) TOFILE(&DMLIB/&JOPCAB) +
                          TOMBR(&JOPCAB) MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817)

/* May be up to 20 intra day A/C balance files so need to loop */
/* to delete them all                                          */
             CHGVAR     VAR(&NUM) VALUE(1)
 LOOP1:
             CHGVAR     VAR(&SEQ) VALUE(&NUM)
             CHGVAR     VAR(&FILE7) VALUE('APBL' *CAT &DAY)
             CHGVAR     VAR(&FILE10) VALUE(&FILE7 *CAT &SEQ)
             DLTF       FILE(&FILE10)
             MONMSG     MSGID(CPF0000 MCH0000)

             CHGVAR     VAR(&NUM) VALUE(&NUM + 1)

             IF         COND(&NUM *NE 21) THEN(DO)
             GOTO       CMDLBL(LOOP1)
             ENDDO

/* May be up to 20 intra day incoming files so need to loop */
/* to delete them all                                       */
             CHGVAR     VAR(&NUM) VALUE(1)
 LOOP2:
             CHGVAR     VAR(&SEQ) VALUE(&NUM)
             CHGVAR     VAR(&FILE7) VALUE('APIN' *CAT &DAY)
             CHGVAR     VAR(&FILE10) VALUE(&FILE7 *CAT &SEQ)
             DLTF       FILE(&FILE10)
             MONMSG     MSGID(CPF0000 MCH0000)

             CHGVAR     VAR(&NUM) VALUE(&NUM + 1)

             IF         COND(&NUM *NE 21) THEN(DO)
             GOTO       CMDLBL(LOOP2)
             ENDDO

/* Make copies of all intra day files generated today */
             CHGVAR     VAR(&NUM) VALUE(1)
 LOOP3:
             CHGVAR     VAR(&SEQ) VALUE(&NUM)
             CHGVAR     VAR(&FILE7) VALUE(&JIFILE)
             CHGVAR     VAR(&FILE10) VALUE(&FILE7 *TCAT &SEQ)

             CHKOBJ     OBJ(&FILE10) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             GOTO       CMDLBL(SKIP3)
             ENDDO

             CHGVAR     VAR(&FILE7) VALUE('APIN' *CAT &DAY)
             CHGVAR     VAR(&FILE10B) VALUE(&FILE7 *CAT &SEQ)
             CPYF       FROMFILE(&FILE10) TOFILE(&DMLIB/&FILE10B) +
                          TOMBR(&FILE10B) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
 SKIP3:
             CHGVAR     VAR(&NUM) VALUE(&NUM + 1)

             IF         COND(&NUM *NE 21) THEN(DO)
             GOTO       CMDLBL(LOOP3)
             ENDDO

             CHGVAR     VAR(&NUM) VALUE(1)
 LOOP4:
             CHGVAR     VAR(&SEQ) VALUE(&NUM)
             CHGVAR     VAR(&FILE7) VALUE(&JOIAB)
             CHGVAR     VAR(&FILE10) VALUE(&FILE7 *TCAT &SEQ)

             CHKOBJ     OBJ(&FILE10) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             GOTO       CMDLBL(SKIP4)
             ENDDO

             CHGVAR     VAR(&FILE7) VALUE('APBL' *CAT &DAY)
             CHGVAR     VAR(&FILE10B) VALUE(&FILE7 *CAT &SEQ)
             CPYF       FROMFILE(&FILE10) TOFILE(&DMLIB/&FILE10B) +
                          TOMBR(&FILE10B) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
 SKIP4:
             CHGVAR     VAR(&NUM) VALUE(&NUM + 1)

             IF         COND(&NUM *NE 21) THEN(DO)
             GOTO       CMDLBL(LOOP4)
             ENDDO

/**/
/* All Copying of files has occured so delete todays files */
/**/
             DLTF       FILE(&JOTREC)
             MONMSG     MSGID(CPF0000 MCH0000)
             DLTF       FILE(&JOTFAB)
             MONMSG     MSGID(CPF0000 MCH0000)
             DLTF       FILE(&JOTCAB)
             MONMSG     MSGID(CPF0000 MCH0000)

             CHGVAR     VAR(&NUM) VALUE(1)
 LOOP5:
             CHGVAR     VAR(&SEQ) VALUE(&NUM)
             CHGVAR     VAR(&FILE7) VALUE(&JIFILE)
             CHGVAR     VAR(&FILE10) VALUE(&FILE7 *TCAT &SEQ)

             DLTF       FILE(&FILE10)
             MONMSG     MSGID(CPF0000 MCH0000)

             CHGVAR     VAR(&NUM) VALUE(&NUM + 1)

             IF         COND(&NUM *NE 21) THEN(DO)
             GOTO       CMDLBL(LOOP5)
             ENDDO

             CHGVAR     VAR(&NUM) VALUE(1)
 LOOP6:
             CHGVAR     VAR(&SEQ) VALUE(&NUM)
             CHGVAR     VAR(&FILE7) VALUE(&JOIAB)
             CHGVAR     VAR(&FILE10) VALUE(&FILE7 *TCAT &SEQ)

             DLTF       FILE(&FILE10)
             MONMSG     MSGID(CPF0000 MCH0000)

             CHGVAR     VAR(&NUM) VALUE(&NUM + 1)

             IF         COND(&NUM *NE 21) THEN(DO)
             GOTO       CMDLBL(LOOP6)
             ENDDO

             GOTO       CMDLBL(END)
 ABNOR:

              CHGJOB     SWS(XXXXXX11)

/*            SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program GLCJ109 +
                           ended abnormally - see job log') TOMSGQ(MOPERQ) */ /*EML110*/
              SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program XXCJ119 +
                           ended abnormally - see job log') TOMSGQ(MOPERQ) +
                           /*EML110*/
                MONMSG     MSGID(CPF0000 MCH0000)

/* END:           CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International Banking +
                             Systems Ltd.') */ /*EML110*/
 END:           CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited +
                             2018') /*EML110*/

              ENDPGM
