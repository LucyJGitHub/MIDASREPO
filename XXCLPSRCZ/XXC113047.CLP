/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL GCMS MT999 File Transfer Process')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Midas-GCMS Interface Module                         */
/*                                                                   */
/********GLCJ047*-*GCMS*File*Transfer*Process*************************/                   /*JMI113*/
/*       XXC113047 - GCMS File Transfer Process                      */                   /*JMI113*/
/*                                                                   */
/*       Function: This program checks each message file for each    */
/******************member*of*LF/GLMREFL0*by*calling*GLJ047.*It*then***/                   /*JMI113*/
/*                 member of LF/XXMREFL0 by calling XX113047. It     */                   /*JMI113*/
/*                 transfers*the*file*using*GLCJ007.*GLJ047*is*then  */
/******************transfers*the*file*using*GLCJ049.*GLJ047*is*then***/                   /*JMI113*/
/*                 transfers the file using XXC113049. XX113047 is   */                   /*JMI113*/
/*                 recalled to update the status of the file on      */
/******************LF/GLMREFL0.*Finally*when*all*accepted*files*have**/                   /*JMI113*/
/*                 LF/XXMREFL0. Finally when all accepted files have */                   /*JMI113*/
/*                 been listed, all files are checked by calling     */
/******************GLCJ004.*******************************************/                   /*JMI113*/
/*                 XXC113004.                                        */                   /*JMI113*/
/*                                                                   */
/********(c)*Misys*International*Banking*Systems*Ltd.*2007************/                   /*JMI113*/
/*       (c) Finastra International Limited 2018                     */                   /*JMI113*/
/*                                                                   */
/*       Last Amend No. JMI113             Date 23May18              */
/*       Prev Amend No. JMI019             Date 21Feb07              */
/*                      JMI019  *CREATE    Date 03Oct05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       JMI113 - Midas GCMS Interface. Upgrade to FBM 2.1           */
/*       JMI019 - Upgrade as is                                      */
/*       JMI019 - Replace GLGOINPD with GLG9INPD                     */
/*                Replace GLCJ007 with GLCJ049                       */
/*       JMI019 - Phase III MT999 Message Processing                 */
/*                                                                   */
/*********************************************************************/

             PGM

/* Copyright statement.                                              */

/*           DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2007')                                      */                  /*JMI113*/
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
             DCL        VAR(&F3MBRN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&F3DNLS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(10 0)

/* Declare file.                                                     */
/*           DCLF       FILE(GLMREFL0)                               */                   /*JMI113*/
             DCLF       FILE(XXMREFL0)                                                    /*JMI113*/

/* Global Message Monitor.                                           */
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ABNOR))

/* Send message to MRUNQ.                                            */
/*           SNDPGMMSG  MSG('GLCJ047 - GCMS MT999 File Processing') +
                          TOMSGQ(MRUNQ)                              */                   /*JMI113*/
             SNDPGMMSG  MSG('XXC113047 - GCMS MT999 File +
                          Processing') TOMSGQ(MRUNQ) /*JMI113*/

/* Set off all user job switches.                                   */
             CHGJOB     SWS(00000000)

/*           OVRDBF     FILE(GLMREFL0) SHARE(*NO)                   */                    /*JMI113*/
             OVRDBF     FILE(XXMREFL0) SHARE(*NO)                                         /*JMI113*/

/**Recieve*first*record*from*GLMREFL0.********************************/                   /*JMI113*/
/* Receive first record from XXMREFL0.                               */                   /*JMI113*/
 LOOP:       RCVF
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDLOOP))

/* If file is not already processed, do transfer request */

             IF         COND(&F3DNLS = 'P' *OR &F3DNLS = 'R') THEN(DO)
/**********    CLRPFM     FILE(GLGOINPD)                                                  /*JMI019*/
/*             CLRPFM     FILE(GLG9INPD)                             */        /*JMI019*/ /*JMI113*/
               CLRPFM     FILE(XXG9INPD)                                                  /*JMI113*/

/* Retrieve system ID from Data area SDSTAT.                         */
               RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSPRE)

/**Set*parameters*for*calling*GLJ047.*********************************/                   /*JMI113*/
/* Set parameters for calling XX113047.                              */                   /*JMI113*/
               CHGVAR     VAR(&LIBNAM) VALUE(&SYSPRE *CAT 'DMLIB')
               CHGVAR     VAR(&MODE) VALUE('*SEND')
               CHGVAR     VAR(&MBRNM) VALUE(&F3MBRN)
               CHGVAR     VAR(&MTYPE) VALUE('999')
               CHGVAR     VAR(&RTCD) VALUE(' ')
               CHGVAR     VAR(&MAXTRY) VALUE('0')
               CHGVAR     VAR(&HOST) VALUE(' ')

/**Call*GLJ047*to*set*up*transfer*request.****************************/                   /*JMI113*/
/* Call XX113047 to set up transfer request.                         */                   /*JMI113*/
/*             CALL       PGM(GLJ047) PARM(&MODE &LIBNAM &MBRNM +
                          &MTYPE &RTCD &MAXTRY &HOST)                */                   /*JMI113*/
               CALL       PGM(XX113047) PARM(&MODE &LIBNAM &MBRNM +
                            &MTYPE &RTCD &MAXTRY &HOST) /*JMI113*/

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
/*                  RTVMBRD FILE(GLMDTAPD) MBR(&F3MBRN) NBRCURRCD(&COUNT) */              /*JMI113*/
                    RTVMBRD FILE(XXMDTAPD) MBR(&F3MBRN) NBRCURRCD(&COUNT)                 /*JMI113*/
                    IF           COND(&COUNT >  0) THEN(DO)

/**Call*GLCJ007*to*transfer*the*file.                                */                   /*JMI019*/
/**********          CALL       PGM(GLCJ007) PARM(&HOST &MAXTRY &RTCD)                    /*JMI019*/
/**Call*GLCJ049*to*transfer*the*file.*********************************/        /*JMI019*/ /*JMI113*/
/* Call XXC113049 to transfer the file.                              */                   /*JMI113*/
/*                   CALL       PGM(GLCJ049) PARM(&HOST &MAXTRY &RTCD)    */   /*JMI019*/ /*JMI113*/
                     CALL       PGM(XXC113049) PARM(&HOST &MAXTRY &RTCD)                  /*JMI113*/

/**If*transfer*was*successful,*then*call*GLJ047*to*update*file.*******/                   /*JMI113*/
/* If transfer was successful, then call XX113047 to update file.    */                   /*JMI113*/
                     IF         COND(&RTCD *EQ 'READY') THEN(DO)

/**Set*up*parameters*for*calling*GLJ047.******************************/                   /*JMI113*/
/* Set up parameters for calling XX113047.                           */                   /*JMI113*/
                     CHGVAR     VAR(&MODE) VALUE('*DOWNLD')
                     CHGVAR     VAR(&LIBNAM) VALUE(' ')
                     CHGVAR     VAR(&MBRNM) VALUE(&F3MBRN)
                     CHGVAR     VAR(&MTYPE) VALUE('999')
                     CHGVAR     VAR(&RTCD) VALUE(' ')
                     CHGVAR     VAR(&MAXTRY) VALUE('0')
                     CHGVAR     VAR(&HOST) VALUE(' ')

/*                   CALL       PGM(GLJ047) PARM(&MODE &LIBNAM &MBRNM +
                              &MTYPE &RTCD &MAXTRY &HOST)              */                 /*JMI113*/
                     CALL       PGM(XX113047) PARM(&MODE &LIBNAM +
                                  &MBRNM &MTYPE &RTCD &MAXTRY &HOST) +
                                  /*JMI113*/

                     ENDDO

/**Transfer*was*not*successful,*call*GLJ047*to*update*file.***********/                   /*JMI113*/
/* Transfer was not successful, call XX113047 to update file.        */                   /*JMI113*/
                     ELSE       CMD(DO)

/**Set*up*parameters*for*calling*GLJ047*******************************/                   /*JMI113*/
/* Set up parameters for calling XX113047                            */                   /*JMI113*/
                     CHGVAR     VAR(&MODE) VALUE('*FAIL')
                     CHGVAR     VAR(&LIBNAM) VALUE(' ')
                     CHGVAR     VAR(&MBRNM) VALUE(&F3MBRN)
                     CHGVAR     VAR(&MTYPE) VALUE('999')
                     CHGVAR     VAR(&RTCD) VALUE(' ')
                     CHGVAR     VAR(&MAXTRY) VALUE('0')
                     CHGVAR     VAR(&HOST) VALUE(' ')

/*                   CALL       PGM(GLJ047) PARM(&MODE &LIBNAM &MBRNM +
                              &MTYPE &RTCD &MAXTRY &HOST)           */                    /*JMI113*/
                     CALL       PGM(XX113047) PARM(&MODE &LIBNAM +
                                  &MBRNM &MTYPE &RTCD &MAXTRY &HOST) +
                                  /*JMI113*/
                     GOTO       CMDLBL(ABNOR)
                     ENDDO
                    ENDDO
                   ENDDO
                 ENDDO
               ENDDO
             GOTO       CMDLBL(LOOP)

/* All MT999 messages have been sent,                                */
 ENDLOOP:

/* All files have been sent, check status of accepted files.         */
/**********  CLRPFM     FILE(GLGOINPD)                                                    /*JMI019*/
/*           CLRPFM     FILE(GLG9INPD)             */                         /*JMI019*/  /*JMI113*/
             CLRPFM     FILE(XXG9INPD)                                                    /*JMI113*/

/**Set*up*parameters*for*calling*of*GLJ047.***************************/                   /*JMI113*/
/* Set up parameters for calling of XX113047.                        */                   /*JMI113*/
             CHGVAR     VAR(&MODE) VALUE('*CHECK')
             CHGVAR     VAR(&LIBNAM) VALUE(' ')
             CHGVAR     VAR(&MBRNM) VALUE(' ')
             CHGVAR     VAR(&MTYPE) VALUE('   ')
             CHGVAR     VAR(&RTCD) VALUE(' ')
             CHGVAR     VAR(&MAXTRY) VALUE('0')
             CHGVAR     VAR(&HOST) VALUE(' ')

/**Call*GLJ047*to*set*up*list*request.********************************/                   /*JMI113*/
/* Call XX113047 to set up list request.                             */                   /*JMI113*/
/*           CALL       PGM(GLJ047) PARM(&MODE &LIBNAM &MBRNM &MTYPE +
                          &RTCD &MAXTRY &HOST)                       */                   /*JMI113*/
             CALL       PGM(XX113047) PARM(&MODE &LIBNAM &MBRNM +
                          &MTYPE &RTCD &MAXTRY &HOST) /*JMI113*/

/**Call*GLCJ004*to*check*accepted files.******************************/                   /*JMI113*/
/* Call XXC113004 to check accepted files.                           */                   /*JMI113*/
             CHGVAR     VAR(&RTCD) VALUE(' ')
/*           CALL       PGM(GLCJ004) PARM(&HOST &MAXTRY &RTCD)       */                   /*JMI113*/
             CALL       PGM(XXC113004) PARM(&HOST &MAXTRY &RTCD)                          /*JMI113*/
             GOTO       CMDLBL(END)

/* Abnormal Processing                                               */
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
/*           SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          GLCJ047 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)                        */                  /*JMI113*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          XXC113047 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ) /*JMI113*/
             MONMSG     MSGID(CPF0000 MCH0000)

 END:        ENDPGM
