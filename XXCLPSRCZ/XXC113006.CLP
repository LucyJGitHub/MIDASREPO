/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL GCMS File Transfer Process')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Midas-GCMS Interface                                */
/*                                                                   */
/********GLCJ006*-*GCMS*File*Transfer*Process*************************/                   /*JMI113*/
/*       XXC113006 - GCMS File Transfer Process                      */                   /*JMI113*/
/*                                                                   */
/*       Function : This program checks each message file for each   */
/*******************member*of*LF/GLGREFL0*by*calling*GLJ006.*It*then**/                   /*JMI113*/
/*******************transfers the file using GLCJ007. GLJ006 is then */                   /*JMI113*/
/*                  mbr of LF/XXGREFL0 by calling XX113006. It then  */                   /*JMI113*/
/*                  transfers the file using XXC113007. XX113006 is  */                   /*JMI113*/
/*                  recalled to update the status of the file on     */
/*******************LF/GLFREFL0.*Finally*when*all*accepted*files*have*/                   /*JMI113*/
/*                  LF/XXFREFL0. Finally when all accepted files have*/                   /*JMI113*/
/*                  been listed, all files are checked by calling    */
/*******************GLCJ004.******************************************/                   /*JMI113*/
/*                  XXC113004.                                       */                   /*JMI113*/
/*                                                                   */
/********(c)*Misys*International*Banking*Systems*Ltd.*2007************/                   /*JMI113*/
/*       (c) Finastra International Limited 2018                     */                   /*JMI113*/
/*                                                                   */
/*       Last Amend No. JMI113             Date 22May18              */
/*       Prev Amend No. JMI019             Date 06Sep07              */
/*                      JMI019             Date 21Feb07              */
/*                      JMI019 (C01)       Date 21Jun05              */
/*                      JMI019  *CREATE    Date 11Jun03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       JMI113 - Midas GCMS Interface. Upgrade to FBM 2.1           */
/*       JMI019 - Additional codes to upgrade                        */
/*       JMI019 - Upgrade as is                                      */
/*       JMI019 (C01) - Midas-GCMS Interface Change Control          */
/*                      Non-accumulation of MT942                    */
/*       JMI019 - Midas-GCMS Interface                               */
/*                                                                   */
/*********************************************************************/

             PGM        PARM(&WAITTM)

/* Copyright statement.                                              */

/*           DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2007')            */                                            /*JMI113*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited 2018.')                          /*JMI113*/
/* Declare variables.                                                */
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
             DCL        VAR(&F3MBRN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&F3DNLS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(10 0)

/* Declare file.                                                     */
  /*         DCLF       FILE(GLGREFL0)                               */                   /*JMI113*/
             DCLF       FILE(XXGREFL0)                                                    /*JMI113*/

/* Global Message Monitor.                                           */
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ABNOR))

/* Send message to MRUNQ.                                            */
/*           SNDPGMMSG  MSG('GLCJ006 - GCMS File Processing') +
                          TOMSGQ(MRUNQ)                              */                   /*JMI113*/
           SNDPGMMSG  MSG('XXC113006 - GCMS File Processing') +
                          TOMSGQ(MRUNQ)                                                   /*JMI113*/

/* Set off all user job switches.                                   */
             CHGJOB     SWS(00000000)

/* Check Line Device and Controller                                  */
/**/
/*       VFYTCPCNN                                                   */
/**/

 /*          OVRDBF     FILE(GLGREFL0) SHARE(*NO)                    */                   /*JMI113*/
             OVRDBF     FILE(XXGREFL0) SHARE(*NO)                                         /*JMI113*/

/**Recieve*first*record*from*GLGREFL0.********************************/                   /*JMI113*/
/* Recieve first record from XXGREFL0.                               */                   /*JMI113*/
 LOOP:       RCVF
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDLOOP))

/* If file is not GCMS942 or not already processed, process          */
/* transfer request.                                                 */
             IF         COND(&F3MBRN *NE 'GCMS942' *AND (&F3DNLS = +
                          'P' *OR &F3DNLS = 'R')) THEN(DO)
/*             CLRPFM     FILE(GLGOINPD)                                                    JMI019*/
/*             CLRPFM     FILE(GLG94IPD)                                */     /*JMI019*/ /*JMI113*/
               CLRPFM     FILE(XXG94IPD)                                                  /*JMI113*/

/* Retrieve system ID from Data area SDSTAT.                         */
               RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSPRE)

/**Set*parameters*for*calling*GLJ006.*********************************/                   /*JMI113*/
/* Set parameters for calling XX113006.                              */                   /*JMI113*/
               CHGVAR     VAR(&LIBNAM) VALUE(&SYSPRE *CAT 'DMLIB')
               CHGVAR     VAR(&MODE) VALUE('*SEND')
               CHGVAR     VAR(&MBRNM) VALUE(&F3MBRN)
               CHGVAR     VAR(&MTYPE) VALUE('940')
               CHGVAR     VAR(&RTCD) VALUE(' ')
               CHGVAR     VAR(&MAXTRY) VALUE('0')
               CHGVAR     VAR(&HOST) VALUE(' ')
               CHGVAR     VAR(&WAITTM) VALUE('0')

/**Call*GLJ006*to*set*up*transfer*request.************               */                   /*JMI113*/
/* Call XX113006 to set-up transfer request.                         */                   /*JMI113*/
/*             CALL       PGM(GLJ006) PARM(&MODE &LIBNAM &MBRNM +
                          &MTYPE &RTCD &MAXTRY &HOST &WAITTM)        */                   /*JMI113*/
               CALL       PGM(XX113006) PARM(&MODE &LIBNAM &MBRNM +
                            &MTYPE &RTCD &MAXTRY &HOST &WAITTM) +
                            /*JMI113*/

                 IF         COND(&RTCD *NE ' ') THEN(DO)
                   IF         COND(&RTCD = 'SENT') THEN(SNDPGMMSG +
                          MSG('File already sent') TOMSGQ(MOPERQ))
                   ELSE       CMD(GOTO CMDLBL(ABNOR))
                 ENDDO
                 ELSE       CMD(DO)

/**Retrieve*GCMS*enabled*flag*from*Data*Area*GLGCMSDA.****************/                   /*JMI113*/
/* Retrieve GCMS enabled flag from Data Area XXGCMGDA.               */                   /*JMI113*/
/*               RTVDTAARA  DTAARA(GLGCMSDA (30 1)) RTNVAR(&GLGCMS)  */                   /*JMI113*/
                 RTVDTAARA  DTAARA(XXGCMGDA (30 1)) RTNVAR(&GLGCMS)                       /*JMI113*/
                   IF           COND(&GLGCMS = 'Y') THEN(DO)
/*                  RTVMBRD FILE(GLGDTAPD) MBR(&F3MBRN) NBRCURRCD(&COUNT)    */           /*JMI113*/
                    RTVMBRD FILE(XXGDTAPD) MBR(&F3MBRN) NBRCURRCD(&COUNT)                 /*JMI113*/
                    IF           COND(&COUNT >  0) THEN(DO)

/**Call*GLCJ007*to*transfer*the*file.*********************************/                   /*JMI113*/
/* Call XXC113007 to transfer the file.                              */                   /*JMI113*/
/*                   CALL       PGM(GLCJ007) PARM(&HOST &MAXTRY &RTCD)       */           /*JMI113*/
                       CALL       PGM(XXC113007) PARM(&HOST &MAXTRY +
                                    &RTCD) /*JMI113*/

/**If*transfer*was*successful,*then*call*GLJ006*to*update*file.*******/                   /*JMI113*/
/* If transfer was successful, then call XX113006 to update file.    */                   /*JMI113*/
                     IF         COND(&RTCD *EQ 'READY') THEN(DO)

/**Set*up*parameters*for*calling*GLJ006.                             */                   /*JMI113*/
/* Set up parameters for calling XX113006.                           */                   /*JMI113*/
                     CHGVAR     VAR(&MODE) VALUE('*DOWNLD')
                     CHGVAR     VAR(&LIBNAM) VALUE(' ')
                     CHGVAR     VAR(&MBRNM) VALUE(&F3MBRN)
                     CHGVAR     VAR(&MTYPE) VALUE('940')
                     CHGVAR     VAR(&RTCD) VALUE(' ')
                     CHGVAR     VAR(&MAXTRY) VALUE('0')
                     CHGVAR     VAR(&HOST) VALUE(' ')
                     CHGVAR     VAR(&WAITTM) VALUE('0')

/*                   CALL       PGM(GLJ006) PARM(&MODE &LIBNAM &MBRNM +
                              &MTYPE &RTCD &MAXTRY &HOST &WAITTM)    */                   /*JMI113*/
                     CALL       PGM(XX113006) PARM(&MODE &LIBNAM +
                                  &MBRNM &MTYPE &RTCD &MAXTRY &HOST +
                                  &WAITTM) /*JMI113*/

                     ENDDO

/**Transfer*was*not*successful,*call*GLJ006*to*update*file.***********/                   /*JMI113*/
/* Transfer was not successful, call XX113006 to update file.        */                   /*JMI113*/
                     ELSE       CMD(DO)

/**Set*up*parameters*for*calling*GLJ006*******************************/                   /*JMI113*/
/* Set up parameters for calling XX113006                            */                   /*JMI113*/
                     CHGVAR     VAR(&MODE) VALUE('*FAIL')
                     CHGVAR     VAR(&LIBNAM) VALUE(' ')
                     CHGVAR     VAR(&MBRNM) VALUE(&F3MBRN)
                     CHGVAR     VAR(&MTYPE) VALUE('940')
                     CHGVAR     VAR(&RTCD) VALUE(' ')
                     CHGVAR     VAR(&MAXTRY) VALUE('0')
                     CHGVAR     VAR(&HOST) VALUE(' ')
                     CHGVAR     VAR(&WAITTM) VALUE('0')

/*                   CALL       PGM(GLJ006) PARM(&MODE &LIBNAM &MBRNM +
                              &MTYPE &RTCD &MAXTRY &HOST &WAITTM)    */                   /*JMI113*/
                     CALL       PGM(XX113006) PARM(&MODE &LIBNAM +
                                  &MBRNM &MTYPE &RTCD &MAXTRY &HOST +
                                  &WAITTM) /*JMI113*/
                     GOTO       CMDLBL(ABNOR)
                     ENDDO
                    ENDDO
                   ENDDO
                 ENDDO
               ENDDO
             GOTO       CMDLBL(LOOP)

/* All MT940 messages have been sent, transfer MT942 file.           */
/* ENDLOOP:    RTVDTAARA  DTAARA(GLGCMSDA (27 1)) RTNVAR(&GLGCMS)    */                   /*JMI113*/
 ENDLOOP:    RTVDTAARA  DTAARA(XXGCMGDA (27 1)) RTNVAR(&GLGCMS)                           /*JMI113*/
             IF         COND(&GLGCMS *EQ 'Y') THEN(DO)
/*             CLRPFM     FILE(GLGOINPD)                                                    JMI019*/
/*             CLRPFM     FILE(GLG94IPD)                             */        /*JMI019*/ /*JMI113*/
               CLRPFM     FILE(XXG94IPD)                                                  /*JMI113*/

/* Retrieve system ID from Data area SDSTAT.                         */
               RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSPRE)

/**Set*up*parameters*for*calling*of*GLJ006.***************************/                   /*JMI113*/
/* Set up parameters for calling of XX113006.                        */                   /*JMI113*/
               CHGVAR     VAR(&MODE) VALUE('*SEND')
               CHGVAR     VAR(&LIBNAM) VALUE(&SYSPRE *CAT 'DMLIB')
               CHGVAR     VAR(&MBRNM) VALUE('GCMS942')
               CHGVAR     VAR(&MTYPE) VALUE('942')
               CHGVAR     VAR(&RTCD) VALUE(' ')
               CHGVAR     VAR(&MAXTRY) VALUE('0')
               CHGVAR     VAR(&HOST) VALUE(' ')
               CHGVAR     VAR(&WAITTM) VALUE('0')

/**Call*GLJ006*to*set*up*transfer*request*for*MT942*file.*********** */                   /*JMI113*/
/* Call XX113006 to set up transfer request for MT942 file.           */                  /*JMI113*/
/*             CALL       PGM(GLJ006) PARM(&MODE &LIBNAM &MBRNM +
                          &MTYPE &RTCD &MAXTRY &HOST &WAITTM)         */                  /*JMI113*/
               CALL       PGM(XX113006) PARM(&MODE &LIBNAM &MBRNM &MTYPE &RTCD &MAXTRY &HOST +
                            &WAITTM) /*JMI113*/


               IF         COND(&RTCD *NE ' ') THEN(DO)
                 IF         COND(&RTCD = SENT) THEN(DO)
                 SNDPGMMSG  MSG('File already sent.') TOMSGQ(MOPERQ)
                 ENDDO
                 ELSE       CMD(GOTO CMDLBL(ABNOR))
                 ENDDO
               ELSE       CMD(DO)
 /*            RTVDTAARA  DTAARA(GLGCMSDA (30 1)) RTNVAR(&GLGCMS)        */               /*JMI113*/
               RTVDTAARA  DTAARA(XXGCMGDA (30 1)) RTNVAR(&GLGCMS)                         /*JMI113*/
                 IF         COND(&GLGCMS = 'Y') THEN(DO)
/*                RTVMBRD FILE(GLGDTAPD) MBR(GCMS942) NBRCURRCD(&COUNT)  */               /*JMI113*/
                  RTVMBRD FILE(XXGDTAPD) MBR(GCMS942) NBRCURRCD(&COUNT)                   /*JMI113*/
                  IF           COND(&COUNT >  0) THEN(DO)

/**Call*GLCJ007*to*transfer*GCMS942*member.***************************/                   /*JMI113*/
/* Call XXC113007 to transfer GCMS942 member.                        */                   /*JMI113*/
/*                 CALL       PGM(GLCJ007) PARM(&HOST &MAXTRY &RTCD) */                   /*JMI113*/
                     CALL       PGM(XXC113007) PARM(&HOST &MAXTRY +
                                  &RTCD) /*JMI113*/

/**Transfer*successful,*call*GLJ006*to*update*file.******************/                    /*JMI113*/
/* Transfer successful, call XX113006 to update file.               */                    /*JMI113*/
                   IF         COND(&RTCD *EQ 'READY') THEN(DO)

/**Set*up*parameters*for*calling*of*GLJ006.***************************/                   /*JMI113*/
/* Set up parameters for calling of XX113006.                        */                   /*JMI113*/
                   CHGVAR     VAR(&MODE) VALUE('*DOWNLD')
                   CHGVAR     VAR(&LIBNAM) VALUE(' ')
                   CHGVAR     VAR(&MBRNM) VALUE('GCMS942')
                   CHGVAR     VAR(&MTYPE) VALUE('942')
                   CHGVAR     VAR(&RTCD) VALUE(' ')
                   CHGVAR     VAR(&MAXTRY) VALUE('0')
                   CHGVAR     VAR(&HOST) VALUE(' ')
                   CHGVAR     VAR(&WAITTM) VALUE('0')

/*                 CALL       PGM(GLJ006) PARM(&MODE &LIBNAM &MBRNM +
                              &MTYPE &RTCD &MAXTRY &HOST &WAITTM)        */               /*JMI113*/
                   CALL       PGM(XX113006) PARM(&MODE &LIBNAM +
                                &MBRNM &MTYPE &RTCD &MAXTRY &HOST +
                                &WAITTM) /*JMI113*/
                                                                                      /*JMI019*/
/**Accumulate*records*in*GLGCM2PP**/                                           /*JMI019*/ /*JMI113*/
/* Accumulate records in XXGCM2PP */                                                      /*JMI113*/
/*                 CPYF       FROMFILE(GLGCM1PP) TOFILE(GLGCM2PP) +
                              MBROPT(*ADD)          */                         /*JMI019*/ /*JMI113*/
                   CPYF       FROMFILE(XXGCM1PP) TOFILE(XXGCM2PP) +
                              MBROPT(*ADD)                                                /*JMI113*/
                   MONMSG     MSGID(CPF0000 MCH0000)                                  /*JMI019*/
                                                                                      /*JMI019*/
/*                 CLRPFM     FILE(GLG94IPD)                     */            /*JMI019*/ /*JMI113*/
                   CLRPFM     FILE(XXG94IPD)                                              /*JMI113*/
                                                                                          /*JMI019*/
/* Retrieve system ID from Data area SDSTAT.                         */                   /*JMI019*/
               RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSPRE)                            /*JMI019*/
                                                                                          /*JMI019*/
/**Set*up*parameters*for*calling*of*GLJ006A.**************************/        /*JMI019*/ /*JMI113*/
/* Set up parameters for calling of XX113006A                        */                   /*JMI113*/
               CHGVAR     VAR(&LIBNAM) VALUE(&SYSPRE *CAT 'DMLIB')                        /*JMI019*/
               CHGVAR     VAR(&MBRNM) VALUE('GCMS942')                                    /*JMI019*/
               CHGVAR     VAR(&MTYPE) VALUE('942')                                        /*JMI019*/
               CHGVAR     VAR(&RTCD) VALUE(' ')                                           /*JMI019*/
               CHGVAR     VAR(&MAXTRY) VALUE('0')                                         /*JMI019*/
               CHGVAR     VAR(&HOST) VALUE(' ')                                           /*JMI019*/
               CHGVAR     VAR(&WAITTM) VALUE('0')                                         /*JMI019*/
                                                                                          /*JMI019*/
/**Call*GLJ006A*to*backup*MT942*if*it*is*successfully*sent************/        /*JMI019*/ /*JMI113*/
/* Call XX113006A to backup MT942 if it is successfully sent         */                   /*JMI113*/
/*             CALL       PGM(GLJ006A) PARM(&MODE &LIBNAM &MBRNM +
                            &MTYPE &RTCD &MAXTRY &HOST &WAITTM)      */                   /*JMI113*/
               CALL       PGM(XX113006A) PARM(&MODE &LIBNAM &MBRNM +
                            &MTYPE &RTCD &MAXTRY &HOST &WAITTM)                           /*JMI113*/
                                                                                          /*JMI019*/
/**Call*GLCJ007*to*transfer*GCMS942*member*TO*BACKUP*SERVER.**********/        /*JMI019*/ /*JMI113*/
/* Call XXC113007 to transfer GCMS942 member to backup server.       */                   /*JMI113*/
/*                 CALL       PGM(GLCJ007) PARM(&HOST &MAXTRY &RTCD) */        /*JMI019*/ /*JMI113*/
               CALL       PGM(XXC113007) PARM(&HOST &MAXTRY &RTCD) +
                            /*JMI113*/
                   ENDDO

/**Transfer*was*not*successful,*call*GLJ006*to*update*file.***********/                   /*JMI113*/
/* Transfer was not successful, call XX113006 to update file.        */                   /*JMI113*/
                   ELSE       CMD(DO)

/**Set*up*parameters*for*calling*of*GLJ006.**************************/                    /*JMI113*/
/* Set up parameters for calling of XX113006.                       */                    /*JMI113*/
                   CHGVAR     VAR(&MODE) VALUE('*FAIL')
                   CHGVAR     VAR(&LIBNAM) VALUE(' ')
                   CHGVAR     VAR(&MBRNM) VALUE('GCMS942')
                   CHGVAR     VAR(&MTYPE) VALUE('942')
                   CHGVAR     VAR(&RTCD) VALUE(' ')
                   CHGVAR     VAR(&MAXTRY) VALUE('0')
                   CHGVAR     VAR(&HOST) VALUE(' ')
                   CHGVAR     VAR(&WAITTM) VALUE('0')

/*                 CALL       PGM(GLJ006) PARM(&MODE &LIBNAM &MBRNM +
                              &MTYPE &RTCD &MAXTRY &HOST &WAITTM)    */                  /*JMI113*/
                   CALL       PGM(XX113006) PARM(&MODE &LIBNAM +
                                &MBRNM &MTYPE &RTCD &MAXTRY &HOST +
                                &WAITTM)                                                 /*JMI113*/
                   ENDDO
                  ENDDO
                 ENDDO
               ENDDO
             ENDDO

/* All files have been sent, check status of accepted files.         */
/*           CLRPFM     FILE(GLGOINPD)                                                      JMI019*/
/*           CLRPFM     FILE(GLG94IPD)                               */        /*JMI019*/ /*JMI113*/
             CLRPFM     FILE(XXG94IPD)                                                    /*JMI113*/

/**Set*up*parameters*for*calling*of*GLJ006.***************************/                   /*JMI113*/
/* Set up parameters for calling of XX113006.                        */                   /*JMI113*/
             CHGVAR     VAR(&MODE) VALUE('*CHECK')
             CHGVAR     VAR(&LIBNAM) VALUE(' ')
             CHGVAR     VAR(&MBRNM) VALUE(' ')
             CHGVAR     VAR(&MTYPE) VALUE('   ')
             CHGVAR     VAR(&RTCD) VALUE(' ')
             CHGVAR     VAR(&MAXTRY) VALUE('0')
             CHGVAR     VAR(&HOST) VALUE(' ')
             CHGVAR     VAR(&WAITTM) VALUE('0')

/**Call*GLJ006*to*set*up*list*request.********************************/                   /*JMI113*/
/* Call XX113006 to set up list request.                             */                   /*JMI113*/
/*           CALL       PGM(GLJ006) PARM(&MODE &LIBNAM &MBRNM &MTYPE +
                          &RTCD &MAXTRY &HOST &WAITTM)               */                   /*JMI113*/
             CALL       PGM(XX113006) PARM(&MODE &LIBNAM &MBRNM +
                          &MTYPE &RTCD &MAXTRY &HOST &WAITTM) +
                          /*JMI113*/

/**Call*GLCJ004*to*check*accepted*files.******************************/                   /*JMI113*/
/* Call XXC113004 to check accepted files.                           */                   /*JMI113*/
             CHGVAR     VAR(&RTCD) VALUE(' ')
/*           CALL       PGM(GLCJ004) PARM(&HOST &MAXTRY &RTCD)       */                   /*JMI113*/
             CALL       PGM(XXC113004) PARM(&HOST &MAXTRY &RTCD) +
                          /*JMI113*/
             GOTO       CMDLBL(END)

/* Abnormal Processing                                               */
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
/*           SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          GLCJ006 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)                       */                   /*JMI113*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                        XXC113006 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)                                            /*JMI113*/
             MONMSG     MSGID(CPF0000 MCH0000)

 END:        ENDPGM
