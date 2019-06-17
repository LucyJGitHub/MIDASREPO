/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL A/C Pool background jobs')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/********GLCJ101*-*Midas*GL*A/C Pooling background jobs startup/down**/  /*JMI108*/
/*       XXCJ101 - Midas GL A/C Pooling background jobs startup/down */  /*JMI108*/
/*                                                                   */
/********(c)*Misys*International*Banking*Systems*Ltd.*2005************/  /*JMI108*/
/*       (c) Finastra International Limited 2018                     */  /*JMI108*/
/*                                                                   */
/*       Last Amend No. JMI108             Date 31May18              */
/*       Prev Amend No. TFJ011  (CHG001)   Date 29Jun05              */
/*                      TFJ011  *CREATE    Date 15Mar05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       JMI108 - Account Balance Pooling. Upgrade to FBM 2.1        */
/*       TFJ011 - (CHG001) User should not be MIDAS10 for Rel 4      */
/*       TFJ011 - Account Pooling                                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&OPTION &TYPE)

             DCL        VAR(&OPTION) TYPE(*CHAR) LEN(5)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PINJNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PINJUS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PINJNB) TYPE(*CHAR) LEN(6)
             DCL        VAR(&APINLNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&APINJNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POTJNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POTJUS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POTJNB) TYPE(*CHAR) LEN(6)
             DCL        VAR(&APOTLNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&APOTJNM) TYPE(*CHAR) LEN(10)
/* Start of JMI108 */
/*           DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Misys +
                          International Banking Systems Ltd. 2005') */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Limited 2018')
/* End of JMI108 */

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/* Create local data area */

             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local data area') AUT(*ALL)
             MONMSG     MSGID(CPF1023)

             CHGDTAARA  DTAARA(LDA) VALUE(' ')

             CHGJOB     SWS(XXXXXX00)

/* Main processing */

             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(&DPLIB) VALUE(&SYSID *TCAT 'DPLIB')

/* If needing to start the Receive FTP job */
             IF         COND(&TYPE = 'R') THEN(DO)
/* Create data area name */
                CHGVAR     VAR(&APINLNM) VALUE('PINLDTA')
/* STOP Process */

                IF         COND(&OPTION *EQ 'STOP      ') THEN(DO)

                   CHGVAR     VAR(&APINJNM) VALUE('PINJDTA')
                   RTVDTAARA  DTAARA(&APINJNM (1 10)) RTNVAR(&PINJNM)
                   RTVDTAARA  DTAARA(&APINJNM (11 10)) RTNVAR(&PINJUS)
                   RTVDTAARA  DTAARA(&APINJNM (21 6)) RTNVAR(&PINJNB)

/* Attempt to allocate data area; if able to do so then don't end job. */
                   ALCOBJ     OBJ((&APINLNM *DTAARA *EXCL)) WAIT(0)
                   MONMSG     MSGID(CPF1002 CPF1085) EXEC(DO)
   /* If job information is blank then end abnormally. */
                      IF         COND(&APINJNM *EQ ' ') THEN(DO)
                         GOTO       CMDLBL(ABNOR)
                      ENDDO
                      ENDJOB     JOB(&PINJNB/&PINJUS/&PINJNM) OPTION(*IMMED)
                      CHGDTAARA  DTAARA(&APINJNM) VALUE(' ')
                   ENDDO
/* If data area was allocated then de-allocate. */
                   DLCOBJ     OBJ((&APINLNM *DTAARA *EXCL))

                ENDDO

/* START Process */
                IF         COND(&OPTION *EQ 'START     ') THEN(DO)

/* Try to create dtaara */
                   CHKOBJ     OBJ(&DPLIB/&APINLNM) OBJTYPE(*DTAARA)
                   MONMSG     MSGID(CPF0000) EXEC(DO)
                   CRTDTAARA  DTAARA(&DPLIB/&APINLNM) TYPE(*CHAR) +
                          LEN(128) TEXT('Midas A/C Pool In Data Area') +
                          AUT(*ALL)
                   ENDDO

                   ALCOBJ     OBJ((&APINLNM *DTAARA *EXCL)) WAIT(0)

/* Unable to allocate, Job is already active */
                   MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(END))

/* Able to allocate, Job is not running */
                   DLCOBJ     OBJ((&APINLNM *DTAARA *EXCL))
                   CHGVAR     VAR(&PINJNM) VALUE('ACPOOL_REC')
/**********  SBMJOB     CMD(CALL PGM(GLCJ102)) JOB(&PINJNM) +
                          JOBD(MBATCH) JOBQ(BULKTJOBQ) OUTQ(*JOBD) +
                          USER(MIDAS10) RTGDTA(*JOBD) INLLIBL(*JOBD)                   */ /*CHG001*/
/****        SBMJOB     CMD(CALL PGM(GLCJ102)) JOB(&PINJNM) +
                          JOBD(MBATCH) JOBQ(BULKTJOBQ) OUTQ(*JOBD) +
                          USER(*JOBD) RTGDTA(*JOBD) INLLIBL(*JOBD) */ /*CHG001*/ /*JMI108*/
                   SBMJOB     CMD(CALL PGM(XXCJ112)) JOB(&PINJNM) JOBD(MBATCH) +
                                JOBQ(BULKTJOBQ) OUTQ(*JOBD) USER(*JOBD) +
                                RTGDTA(*JOBD) INLLIBL(*JOBD) /*JMI108*/

                ENDDO
                ENDDO

/* If needing to start the Send FTP job */
             IF         COND(&TYPE = 'S') THEN(DO)
/* Create data area name */
                CHGVAR     VAR(&APOTLNM) VALUE('POTLDTA')
/* STOP Process */

                IF         COND(&OPTION *EQ 'STOP      ') THEN(DO)

                   CHGVAR     VAR(&APOTJNM) VALUE('POTJDTA')
                   RTVDTAARA  DTAARA(&APOTJNM (1 10)) RTNVAR(&POTJNM)
                   RTVDTAARA  DTAARA(&APOTJNM (11 10)) RTNVAR(&POTJUS)
                   RTVDTAARA  DTAARA(&APOTJNM (21 6)) RTNVAR(&POTJNB)

/* Attempt to allocate data area; if able to do so then don't end job. */
                   ALCOBJ     OBJ((&APOTLNM *DTAARA *EXCL)) WAIT(0)
                   MONMSG     MSGID(CPF1002 CPF1085) EXEC(DO)
   /* If job information is blank then end abnormally. */
                      IF         COND(&APOTJNM *EQ ' ') THEN(DO)
                         GOTO       CMDLBL(ABNOR)
                      ENDDO
                      ENDJOB     JOB(&POTJNB/&POTJUS/&POTJNM) OPTION(*IMMED)
                      CHGDTAARA  DTAARA(&APOTJNM) VALUE(' ')
                   ENDDO
/* If data area was allocated then de-allocate. */
                   DLCOBJ     OBJ((&APOTLNM *DTAARA *EXCL))

                ENDDO

/* START Process */
                IF         COND(&OPTION *EQ 'START     ') THEN(DO)

/* Try to create dtaara */
                   CHKOBJ     OBJ(&DPLIB/&APOTLNM) OBJTYPE(*DTAARA)
                   MONMSG     MSGID(CPF0000) EXEC(DO)
                   CRTDTAARA  DTAARA(&DPLIB/&APOTLNM) TYPE(*CHAR) +
                          LEN(128) TEXT('Midas A/C Pool Out Data Area') +
                          AUT(*ALL)
                   ENDDO

                   ALCOBJ     OBJ((&APOTLNM *DTAARA *EXCL)) WAIT(0)

/* Unable to allocate, Job is already active */
                   MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(END))

/* Able to allocate, Job is not running */
                   DLCOBJ     OBJ((&APOTLNM *DTAARA *EXCL))
                   CHGVAR     VAR(&POTJNM) VALUE('ACPOOL_SND')
/**********  SBMJOB     CMD(CALL PGM(GLCJ103)) JOB(&POTJNM) +
                          JOBD(MBATCH) JOBQ(BULKTJOBQ) OUTQ(*JOBD) +
                          USER(MIDAS10) RTGDTA(*JOBD) INLLIBL(*JOBD)                   */ /*CHG001*/
/*                 SBMJOB     CMD(CALL PGM(GLCJ103)) JOB(&POTJNM) JOBD(MBATCH) +
                                JOBQ(BULKTJOBQ) OUTQ(*JOBD) USER(*JOBD) +
                                RTGDTA(*JOBD) INLLIBL(*JOBD) */ /*CHG001*/ /*JMI108*/
                   SBMJOB     CMD(CALL PGM(XXCJ113)) JOB(&POTJNM) JOBD(MBATCH) +
                                JOBQ(BULKTJOBQ) OUTQ(*JOBD) USER(*JOBD) +
                                RTGDTA(*JOBD) INLLIBL(*JOBD) /*JMI108*/
                ENDDO
                ENDDO
             GOTO       CMDLBL(END)

 ABNOR:

             CHGJOB     SWS(XXXXXX11)

/*           SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program GLCJ101 ended +
                          abnormally - see job log') TOMSGQ(MOPERQ)  */ /*JMI108*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program XXCJ111 ended +
                          abnormally - see job log') TOMSGQ(MOPERQ) /*JMI108*/
               MONMSG     MSGID(CPF0000 MCH0000)

/* END:          CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International Banking +
                            Systems Ltd.')  */ /*JMI108*/
 END:          CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited +
                            2018') /*JMI108*/

             ENDPGM
