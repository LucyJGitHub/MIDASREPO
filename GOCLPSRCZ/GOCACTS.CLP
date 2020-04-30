/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GO Bulk sync of global layer - task split')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOCACTS - Bulk Synchronisation of Global Layer (with Zone)  */
/*                 Task Split version replacing GOC0100              */
/*                 Also, see GOCACDL                                 */
/*                                                                   */
/*   WARNING - THIS PROGRAM IS RUNNING IN TASK SPLIT MODE.           */                 /*CGO001AA*/
/*             DO NOT ADD ANY NEW PROGRAMS TO THIS CL IF IT IS NOT   */                 /*CGO001AA*/
/*             ABLE TO RUN IN TASK SPLIT.                            */                 /*CGO001AA*/
/*                                                                   */                 /*CGO001AA*/
/*       (c) Finastra International Limited 2009                     */
/*                                                                   */
/*       Last Amend No. MD055146           Date 04Feb20              */
/*       Prev Amend No. MD052296           Date 26Nov18              */
/*                      MD046248           Date 27Oct17              */
/*                      AR1097467          Date 17Apr13              */
/*                      CGO001AA           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      CGP013  *CREATE    Date 20Feb09              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD055146 - Failed MXC004802 seq. 00001 and others           */
/*                  Increase Branches to 900.                        */
/*       MD052296 - Problems caused by use of special characters     */
/*       MD046248 - Finastra Rebranding                              */
/*       AR1097467B - Expected 15% COB run optimization not met      */
/*       CGO001AA - COB Restructure - GO COB Optimisation Phase 1    */
/*       CGP013 - Task Split for Accounts Global Update              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)

             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&CSEQC) TYPE(*CHAR) LEN(5)
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(12)
/**********  DCL        VAR(&DTAQLIBL) TYPE(*CHAR) LEN(10)           */               /*AR1097467B*/
/**********  DCL        VAR(&MSGLENGTH) TYPE(*DEC) LEN(5 0) VALUE(50)*/               /*AR1097467B*/
/**********  DCL        VAR(&MSGDATA) TYPE(*CHAR) LEN(50)            */               /*AR1097467B*/
/**********  DCL        VAR(&SNDDTAQ) TYPE(*CHAR) LEN(10)            */               /*AR1097467B*/
/**********  DCL        VAR(&RCVWAIT) TYPE(*DEC) LEN(5 0) VALUE(600) */               /*AR1097467B*/
             DCL        VAR(&RESTART) TYPE(*CHAR) LEN(1)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(3 0) VALUE(0)
             DCL        VAR(&RTCD)  TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&FULLCHECK) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&ZOZONE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&ZOSHTC)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&ZORDNB)  TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&ZODNWD)  TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&ZOBCCY)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&ZONJOB)  TYPE(*DEC)  LEN(1 0)

             DCL        VAR(&GPF) TYPE(*CHAR) LEN(10) VALUE(GZACCNTAB)
             DCL        VAR(&GLFU)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&ZLFOVR)  TYPE(*CHAR) LEN(60)
             DCL        VAR(&GLFOVR)  TYPE(*CHAR) LEN(60)
             DCL        VAR(&GLFCLO)  TYPE(*CHAR) LEN(60)
             DCL        VAR(&ZLFDLO)  TYPE(*CHAR) LEN(60)
             DCL        VAR(&GLFDLO)  TYPE(*CHAR) LEN(60)
             DCL        VAR(&OPNQRY)  TYPE(*CHAR) LEN(32702)
             DCL        VAR(&ZLF   )  TYPE(*CHAR) LEN(10)
             DCL        VAR(&BLFD  )  TYPE(*CHAR) LEN(1)
             DCL        VAR(&BLSY  )  TYPE(*CHAR) LEN(1)

             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
                                                                                        /*MD055146*/
             DCL        VAR(&GFGPF)     TYPE(*CHAR) LEN(10)                             /*MD055146*/
             DCL        VAR(&GFGBRC)    TYPE(*CHAR) LEN(10)                             /*MD055146*/
             DCL        VAR(&GFGLF)     TYPE(*CHAR) LEN(10)                             /*MD055146*/
             DCL        VAR(&STM_STR1)  TYPE(*CHAR) LEN(80)                             /*MD055146*/
             DCL        VAR(&STM_STR2)  TYPE(*CHAR) LEN(80)                             /*MD055146*/
             DCL        VAR(&STM_STR3)  TYPE(*CHAR) LEN(80)                             /*MD055146*/
                                                                                        /*MD055146*/
             DCL        VAR(&STM1) TYPE(*CHAR) LEN(42) VALUE('CREATE +
                          VIEW QTEMP/GOFILE AS SELECT * FROM ')                         /*MD055146*/
             DCL        VAR(&STM2)     TYPE(*CHAR) LEN(7) VALUE(' WHERE ')              /*MD055146*/
             DCL        VAR(&STM3)     TYPE(*CHAR) LEN(12) VALUE(' IN (SELECT ')        /*MD055146*/
             DCL        VAR(&STM4)     TYPE(*CHAR) LEN(6) VALUE(' FROM ')               /*MD055146*/
             DCL        VAR(&STM5)     TYPE(*CHAR) LEN(1) VALUE(')')                    /*MD055146*/
                                                                                        /*MD055146*/

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2009')
             DCL        VAR(&STRRRN) TYPE(*DEC) LEN(10 0)                             /*AR1097467B*/
             DCL        VAR(&ENDRRN) TYPE(*DEC) LEN(10 0)                             /*AR1097467B*/
             DCL        VAR(&CSEQ2) TYPE(*DEC) LEN(2 0)                               /*AR1097467B*/
             DCL        VAR(&CSEQ2C) TYPE(*CHAR) LEN(2)                               /*AR1097467B*/
             DCLF       ACTSIXPD                                                      /*AR1097467B*/

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             SNDPGMMSG  MSG('GOCACTS - Bulk Synchronisation of +
                          Global Layer, task-split:' *CAT &GPF) +
                          TOMSGQ(MRUNQ)

             RTVJOBA    TYPE(&JOBTYPE)

             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ')
             MONMSG     MSGID(CPF0000)

             CHGJOB SWS(00000000)

/* Check if normal run or restart */

             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)

/* Check if any problems with COB components file */

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO

             CHGVAR     VAR(&RESTART) VALUE(&STAT)

/* Set restart status to 'Y' */

             CHGVAR     VAR(&STAT) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)

/**Set*up*call*to*QSNDDTAQ*and*override*files*to*their*members**/                     /*AR1097467B*/

/**********  CHGVAR     VAR(&CSEQC) VALUE(&CSEQ)                     */               /*AR1097467B*/
/**********  CHGVAR     VAR(&MEMBER) VALUE('ACTSD' *CAT &CSEQC)      */               /*AR1097467B*/
/**********  CHGVAR     VAR(&DTAQLIBL) VALUE('*LIBL')                */               /*AR1097467B*/
/**********  CHGVAR     VAR(&SNDDTAQ) VALUE('GOACNTSRV')             */               /*AR1097467B*/

/**********  OVRDBF     FILE(ACTSDVPD) TOFILE(ACTSDVPD) MBR(&MEMBER) +
                          NBRRCDS(1000) SEQONLY(*YES 2000)           */               /*AR1097467B*/

/**If*restart,*do*not*wait*for*the*data*queue*entry**/                                /*AR1097467B*/
/**Clear*any*old*data*queue*message*from*server*but*ensure*that*an**/                 /*AR1097467B*/
/**'END'*message,*sent*from*the*end*proc*job*is*not*lost**/                           /*AR1097467B*/

/**********  IF         COND(&RESTART = 'Y') THEN(DO)                */               /*AR1097467B*/
/**********  CHGVAR     VAR(&RCVWAIT) VALUE(5)                       */               /*AR1097467B*/
/**********  CALL       PGM(QRCVDTAQ) PARM(&MEMBER &DTAQLIBL +
                          &MSGLENGTH &MSGDATA &RCVWAIT)              */               /*AR1097467B*/
/**********  CHGVAR     VAR(&RCVWAIT) VALUE(600)                     */               /*AR1097467B*/
/**********  CHGVAR     VAR(&MSGLENGTH) VALUE(50)                    */               /*AR1097467B*/
/**********  IF         COND(%SST(&MSGDATA 1 3) = 'END') THEN(DO)    */               /*AR1097467B*/
/**********  CALL       PGM(QSNDDTAQ) PARM(&MEMBER &DTAQLIBL +
                          &MSGLENGTH &MSGDATA)                       */               /*AR1097467B*/
/**********  ENDDO                                                   */               /*AR1097467B*/
/**********  GOTO       CMDLBL(RESTART)                              */               /*AR1097467B*/
/**********  ENDDO                                                   */               /*AR1097467B*/

/**Check*that*Data*Queue*exists*-*if*not*retry*10*times**/                            /*AR1097467B*/
/***CHKDTAQ:    CHKOBJ     OBJ(&DTAQLIBL/&MEMBER) OBJTYPE(*DTAQ)     */               /*AR1097467B*/
/**********  MONMSG     MSGID(CPF0000) EXEC(DO)                      */               /*AR1097467B*/
/**********             CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)     */               /*AR1097467B*/
/**********             IF         COND(&COUNT *LT 11) THEN(DO)      */               /*AR1097467B*/
/**********                        DLYJOB     DLY(10)                */               /*AR1097467B*/
/**********                        GOTO       CMDLBL(CHKDTAQ)        */               /*AR1097467B*/
/**********             ENDDO                                        */               /*AR1097467B*/
/**********             ELSE (DO)                                    */               /*AR1097467B*/
/**********                        GOTO       CMDLBL(ABNOR)          */               /*AR1097467B*/
/**********             ENDDO                                        */               /*AR1097467B*/
/**********  ENDDO                                                   */               /*AR1097467B*/
/***LOOP:                                                            */               /*AR1097467B*/

/**Request*response*from*DTAQ*whether*to*run*job*again*or*end**/                      /*AR1097467B*/

/**********  CHGVAR     VAR(&MSGDATA) VALUE(&MEMBER)                 */               /*AR1097467B*/
/**********  CALL       PGM(QSNDDTAQ) PARM(&SNDDTAQ &DTAQLIBL +
                          &MSGLENGTH &MSGDATA)                       */               /*AR1097467B*/

/**Wait*on*reply*for*1*hour**/                                                        /*AR1097467B*/
/**********  CHGVAR     VAR(&RCVWAIT) VALUE(3600)                    */               /*AR1097467B*/
/**********  CALL       PGM(QRCVDTAQ) PARM(&MEMBER &DTAQLIBL +
                          &MSGLENGTH &MSGDATA &RCVWAIT)              */               /*AR1097467B*/

/**If*no*reply,*error*message*and*terminate**/                                        /*AR1097467B*/
/**********  IF         COND(&MSGLENGTH = 0) THEN(DO)                */               /*AR1097467B*/
/**********  SNDPGMMSG  MSG('No response from server for GOCACTS') +
                          TOMSGQ(MOPERQ MRUNQ)                       */               /*AR1097467B*/
/**********  GOTO       CMDLBL(ABNOR)                                */               /*AR1097467B*/
/**********  ENDDO                                                   */               /*AR1097467B*/

/**If*reply*=*END,*terminate**/                                                       /*AR1097467B*/
/**********  IF         COND(%SST(&MSGDATA 1 3) = 'END') THEN(DO)    */               /*AR1097467B*/
/**********  GOTO       CMDLBL(ENDCL)                                */               /*AR1097467B*/
/**********  ENDDO                                                   */               /*AR1097467B*/

/**/
/***RESTART:                                                         */               /*AR1097467B*/

             RCVF                                                                     /*AR1097467B*/
             IF       COND(&CSEQ *LT 1000) THEN(DO)                                   /*AR1097467B*/
               CHGVAR     VAR(&STRRRN) VALUE(1)                                       /*AR1097467B*/
               CHGVAR     VAR(&ENDRRN) VALUE(&NORE)                                   /*AR1097467B*/
             ENDDO                                                                    /*AR1097467B*/
             ELSE     DO                                                              /*AR1097467B*/
               CHGVAR     VAR(&CSEQC) VALUE(&CSEQ)                                    /*AR1097467B*/
               CHGVAR     VAR(&CSEQ2C) VALUE(%SST(&CSEQC 4 2))                        /*AR1097467B*/
               CHGVAR     VAR(&CSEQ2) VALUE(&CSEQ2C)                                  /*AR1097467B*/
               CHGVAR     VAR(&STRRRN) VALUE((&CSEQ2 * &NORE) +1 )                    /*AR1097467B*/
               CHGVAR     VAR(&ENDRRN) VALUE((&CSEQ2 + 1) * &NORE)                    /*AR1097467B*/
             ENDDO                                                                    /*AR1097467B*/

/* Get zone */

             CALL       PGM(GOGETZONE) PARM(&RTCD &ERMS &FULLCHECK +
                          &ZOZONE &ZOSHTC &ZORDNB &ZODNWD &ZOBCCY +
                          &ZONJOB)

/* error */                                                                             /*MD052296*/
/**********  IF         COND(&RTCD ¬= '       ') THEN(DO)                               /*MD052296*/
             IF         COND(&RTCD *NE '       ') THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO


/* Get synchronisation executables*/

/**********  CALL       PGM(GOGETSYNX) PARM(&GPF &ZOZONE &GLFU +     */                 /*MD055146*/
/**********               &ZLFOVR &GLFOVR &GLFCLO &ZLFDLO &GLFDLO +  */                 /*MD055146*/
/**********               &OPNQRY &ZLF &BLFD &BLSY)                  */      /*BG1364*/ /*MD055146*/
                                                                                        /*MD055146*/
             CALL       PGM(GOGETSYNX) PARM(&GPF &ZOZONE &GLFU +
                          &ZLFOVR &GLFOVR &GLFCLO &ZLFDLO &GLFDLO +
                          &OPNQRY &ZLF &BLFD &BLSY &GFGPF &GFGBRC +
                          &GFGLF)                                                       /*MD055146*/
                                                                                        /*MD055146*/

/* End if bulk synchronisation not done for this file*/
/**********  IF         COND(&BLSY ¬= 'Y') THEN(DO)                                     /*MD052296*/
             IF         COND(&BLSY *NE 'Y') THEN(DO)                                    /*MD052296*/
              SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Bulk +
                            synchronisation was not done for file ' +
                            *CAT &GPF) TOPGMQ(*EXT)
             GOTO       CMDLBL(ENDCL)
             ENDDO


/* Do bulk synchronisation */
             CALL       PGM(QCMDEXC) PARM(&ZLFOVR 60)
/**********  CALL       PGM(QCMDEXC) PARM(&GLFOVR 60)                                   /*MD055146*/
/**********  CALL       PGM(QCMDEXC) PARM(&OPNQRY 32702)                                /*MD055146*/
                                                                                        /*MD055146*/
             DLTF       FILE(QTEMP/RUNSQLSTM)                                           /*MD055146*/
             MONMSG     MSGID(CPF0000)                                                  /*MD055146*/
             DLTF       FILE(QTEMP/RUNSQL)                                              /*MD055146*/
             MONMSG     MSGID(CPF0000)                                                  /*MD055146*/
             CRTSRCPF   FILE(QTEMP/RUNSQLSTM) RCDLEN(112) +
                          MBR(RUNSQLSTM) TEXT('TEMPORARY SOURCE FILE +
                          FOR RUNSQLSTM')                                               /*MD055146*/
             RNMOBJ     OBJ(QTEMP/RUNSQLSTM) OBJTYPE(*FILE) +
                          NEWOBJ(RUNSQL)                                                /*MD055146*/
             DLTF       FILE(QTEMP/GOFILE)                                              /*MD055146*/
             MONMSG     MSGID(CPF0000)                                                  /*MD055146*/
                                                                                        /*MD055146*/
             CALL       PGM(UTWRTSQL2) PARM(&STM_STR1 &STM_STR2 +
                          &STM_STR3 '*CLEAR')                                           /*MD055146*/
                                                                                        /*MD055146*/
             CHGVAR     VAR(&STM_STR1) VALUE(&STM1 *CAT &GFGPF)                         /*MD055146*/
             CHGVAR     VAR(&STM_STR2) VALUE(&STM2 *CAT &GFGBRC *CAT +
                          &STM3 *CAT 'A8BRCD' *CAT &STM4 *CAT +
                          'GZSDBRCHPD' *CAT &STM5)                                      /*MD055146*/
                                                                                        /*MD055146*/
             CALL       PGM(UTWRTSQL2) PARM(&STM_STR1 &STM_STR2 +
                          &STM_STR3 '*WRITE')                                           /*MD055146*/
             RUNSQLSTM  SRCFILE(QTEMP/RUNSQL) SRCMBR(RUNSQLSTM) +
                          COMMIT(*NONE)                                                 /*MD055146*/
             MONMSG     MSGID(SQL9010)                                                  /*MD055146*/
                                                                                        /*MD055146*/
             OVRDBF     FILE(GOFILE) TOFILE(&GFGLF) SHARE(*YES) +
                          OPNSCOPE(*JOB)                                                /*MD055146*/
                                                                                        /*MD055146*/
             OVRDBF     FILE(&GPF) SEQONLY(*YES 4000)
             OVRDBF     FILE(GPGDRPPD) SEQONLY(*YES 5000)
/* Filter duplicates                                                                  */
             IF (&BLFD = 'Y') THEN(DO)
             OPNQRYF    FILE((&ZLF)) OPTION(*INP) KEYFLD(*FILE) +
                          UNIQUEKEY(*ALL) SEQONLY(*YES 5000)
             ENDDO
/**********  CALL       PGM(GOACCNTAB1) PARM(&ZOZONE)                */               /*AR1097467B*/
             CALL       PGM(GOACCNTAB1) PARM(&ZOZONE &STRRRN &ENDRRN)                 /*AR1097467B*/
/**********  CALL       PGM(QCMDEXC) PARM(&GLFCLO 60)                */                 /*MD055146*/
             CALL       PGM(QCMDEXC) PARM(&ZLFDLO 60)
/**********  CALL       PGM(QCMDEXC) PARM(&GLFDLO 60)                */                 /*MD055146*/
                                                                                        /*MD055146*/
             DLTOVR     FILE(GOFILE)                                                    /*MD055146*/
                                                                                        /*MD055146*/

/* error */
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))

/* Successful completion */
             CHGVAR     VAR(&RESTART) VALUE('N')

             GOTO       ENDCL                                                         /*AR1097467B*/
                                                                                      /*AR1097467B*/
/**********  CLRPFM     FILE(ACTSDVPD) MBR(&MEMBER)                  */               /*AR1097467B*/

/**********  GOTO       CMDLBL(LOOP)                                 */               /*AR1097467B*/

 ABNOR:

             CHGJOB     SWS(XXXXXX11)

             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)

/* Abnormal termination - batch job */

             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            GOCACTS ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO

/* Abnormal termination - interactive job */

             IF         COND(&JOBTYPE = '1') THEN(DO)
                SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          GOCACTS ended abnormally - see job log') +
                          TOPGMQ(*EXT)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO

 ENDCL:      CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited')
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDPGM