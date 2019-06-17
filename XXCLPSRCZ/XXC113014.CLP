/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL GCMS File Transfer Process')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Midas-GCMS Interface                                */
/*                                                                   */
/********GLCJ014*-*GCMS File Transfer Process*************************/        /*JMI113*/
/*       XXC113014 - GCMS File Transfer Process                      */        /*JMI113*/
/*                                                                   */
/********Function*:*This formats the transfer request by calling******/        /*JMI113*/
/*******************GLJ014. It then transfers the file using**********/        /*JMI113*/
/*******************GLCJ013. Then it will call MECJ010 to convert*****/        /*JMI113*/
/*******************MT101 in excel format in SWIFT format*************/        /*JMI113*/
/*       Function : This formats the transfer request by calling     */        /*JMI113*/
/*                  XX113014. It then transfers the file using       */        /*JMI113*/
/*                  XXC113013. Then it will call XXC113110 to convert*/        /*JMI113*/
/*                  MT101 in excel format in SWIFT format            */        /*JMI113*/
/*                                                                   */
/********(c)*Misys International*Banking*Systems*Ltd.*2007************/        /*JMI113*/
/*       (c) Finastra International Limited 2018                     */        /*JMI113*/
/*                                                                   */
/*       Last Amend No. JMI113             Date 22May18              */
/*       Prev Amend No. JMI019  *CREATE    Date 21Feb07              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       JMI113 - Midas GCMS Interface. Upgrade to FBM 2.1           */
/*       JMI019 - Upgrade as is                                      */
/*       JMI019 - Midas GCMS Interface                               */
/*                                                                   */
/*********************************************************************/

             PGM        PARM(&WAITTM)

/** Copyright statement.                          */

/*           DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Misys +
                          International Banking Systems Ltd. 2007') */ /*JMI113*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Limited 2018') /*JMI113*/
/** Declare variables.                            */
             DCL        VAR(&SYSPRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&GLGCMS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&LIBNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBRNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MTYPE) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MAXTRY) TYPE(*DEC) LEN(1)
             DCL        VAR(&HOST) TYPE(*CHAR) LEN(30)
             DCL        VAR(&WAITTM) TYPE(*DEC) LEN(5 0)
/*           DCL        VAR(&F3MBRN) TYPE(*CHAR) LEN(10) VALUE(MGGCEXPD) */ /*JMI113*/
             DCL        VAR(&F3MBRN) TYPE(*CHAR) LEN(10) VALUE(XXGCEXPD) /*JMI113*/

/** Global Message Monitor.                       */
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ABNOR))

/** Send message to MRUNQ.                        */
/*           SNDPGMMSG  MSG('GLCJ014 - GCMS File Processing') TOMSGQ(MRUNQ) */ /*JMI113*/
             SNDPGMMSG  MSG('XXC113014 - GCMS File Processing') TOMSGQ(MRUNQ) +
                          /*JMI113*/

/** Set off all user job switches.                */
             CHGJOB     SWS(00000000)

/**/

/*             CLRPFM     FILE(GLGOINPD) */ /*JMI113*/
             CLRPFM     FILE(XXGOINPD) /*JMI113*/

/** Retrieve system ID from Data area SDSTAT.     */
               RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSPRE)

/***Set*parameters*for*calling*GLJ014.*************/  /*JMI113*/
/** Set parameters for calling XX113014.          */  /*JMI113*/
               CHGVAR     VAR(&LIBNAM) VALUE(&SYSPRE *CAT 'DMLIB')
               CHGVAR     VAR(&MODE) VALUE('*GET')
               CHGVAR     VAR(&MBRNM) VALUE(&F3MBRN)
               CHGVAR     VAR(&MTYPE) VALUE('101')
               CHGVAR     VAR(&RTCD) VALUE(' ')
               CHGVAR     VAR(&MAXTRY) VALUE('0')
               CHGVAR     VAR(&HOST) VALUE(' ')
               CHGVAR     VAR(&WAITTM) VALUE('0')

/***Call*GLJ014*to*set*up*transfer*request.********/
/*             CALL       PGM(GLJ014) PARM(&MODE &LIBNAM &MBRNM &MTYPE &RTCD +
                            &MAXTRY &HOST &WAITTM) */ /*JMI113*/
/** Call XX113014 to set up transfer request.       */ /*JMI113*/
               CALL       PGM(XX113014) PARM(&MODE &LIBNAM &MBRNM &MTYPE &RTCD +
                            &MAXTRY &HOST &WAITTM) /*JMI113*/

               IF         COND(&RTCD *EQ ' ') THEN(DO)

/** Retrieve GCMS enabled flag from Data Area GLGCMSDA. */
/*                  RTVDTAARA  DTAARA(GLGCMSDA (30 1)) RTNVAR(&GLGCMS) */ /*JMI113*/
                  RTVDTAARA  DTAARA(XXGCMGDA (30 1)) RTNVAR(&GLGCMS) /*JMI113*/
                 IF         COND(&GLGCMS = 'Y') THEN(DO)

/***Call*GLCJ013*to*transfer*the*file.*************/ /*JMI113*/
/*                  CALL       PGM(GLCJ013) PARM(&HOST &MAXTRY &RTCD) */ /*JMI113*/
/** Call XXC113013 to transfer the file.            */ /*JMI113*/
                    CALL       PGM(XXC113013) PARM(&HOST &MAXTRY &RTCD) /*JMI113*/

/***If*transfer*was*successful,*then*call*MECJ010**/ /*JMI113*/
/** If transfer was successful, then call XXC113110 */ /*JMI113*/
                     IF         COND(&RTCD *EQ 'READY') THEN(DO)

/***Call*MECJ010,*to*convert MT101 messages from excel to SWIFT format**/ /*JMI113*/

/*                      CALL       PGM(MECJ010) */ /*JMI113*/
/** Call XXC113110, to convert MT101 messages from excel to SWIFT format */ /*JMI113*/

                        CALL       PGM(XXC113110) /*JMI113*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO CMDLBL(END))
                     ENDDO
                 ENDDO
               ENDDO

/** Abnormal Processing                           */
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
/*             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program GLCJ014 ended +
                          abnormally - see job log') TOMSGQ(MOPERQ MRUNQ) */ /*JMI113*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program XXC113014 +
                          ended abnormally - see job log') TOMSGQ(MOPERQ MRUNQ) +
                          /*JMI113*/
             MONMSG     MSGID(CPF0000 MCH0000)

/* END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International Banking +
                          Systems Ltd.') */ /*JMI113*/
 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited +
                          2018') /*JMI113*/

             ENDPGM
