/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GO Bulk synchronization of global layer')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOC0100 - Bulk Synchronisation of Global Layer (with Zone)  */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD055751           Date 22May20              */
/*       Prev Amend No. MD055146           Date 04Feb20              */
/*                      MD046248           Date 27Oct17              */
/*                      MD020205A          Date 27Jun13              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      BUG18886           Date 30May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      243724             Date 15Nov06              */
/*                      242731             Date 29Sep06              */
/*                      CLE041             Date 11Oct04              */
/*                      BG1364             Date 04Mar04              */
/*                      CGP001  *CREATE    Date 23May03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD055751 - Global Sync Issue for GOC0100 during COB         */
/*                  Include zone in the creation of SQL view.        */
/*       MD055146 - Failed MXC004802 seq. 00001 and others           */
/*                  Increase Branches to 900.                        */
/*       MD046248 - Finastra Rebranding                              */
/*       MD020205A - Continuous CoB run time improvement             */
/*       BUG18886 - Non-standard codes exist in Midas Plus core      */
/*                  sources                                          */
/*       243724 - A length that is not valid is specified in the 2nd */
/*                parameter that was sent to QCMDEXC. Fix 242731 has */
/*                been corrected to send the maximum length allowed. */
/*       242731 - Fix to enlarge size of OPNQRYF statement.          */
/*       CLE041 - Collateralised Lending Phase 2B                    */
/*       BG1364 - Filter Duplicate records in Bulk Synchronization   */
/*       CGP001 - Global Processing                                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&GPF)

             DCL        VAR(&RTCD)  TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&FULLCHECK) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&ZOZONE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&ZOSHTC)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&ZORDNB)  TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&ZODNWD)  TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&ZOBCCY)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&ZONJOB)  TYPE(*DEC)  LEN(1 0)

             DCL        VAR(&GPF )    TYPE(*CHAR) LEN(10)
             DCL        VAR(&GLFU)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM )    TYPE(*CHAR) LEN(10)
             DCL        VAR(&ZLFOVR)  TYPE(*CHAR) LEN(60)
             DCL        VAR(&GLFOVR)  TYPE(*CHAR) LEN(60)
             DCL        VAR(&GLFCLO)  TYPE(*CHAR) LEN(60)
             DCL        VAR(&ZLFDLO)  TYPE(*CHAR) LEN(60)
             DCL        VAR(&GLFDLO)  TYPE(*CHAR) LEN(60)
/**********  DCL        VAR(&OPNQRY)  TYPE(*CHAR) LEN(5000)                            */ /*242731*/
/**********  DCL        VAR(&OPNQRY)  TYPE(*CHAR) LEN(32767)                */ /*242731*/ /*243724*/
             DCL        VAR(&OPNQRY)  TYPE(*CHAR) LEN(32702)                              /*243724*/
             DCL        VAR(&ZLF   )  TYPE(*CHAR) LEN(10)                                 /*BG1364*/
             DCL        VAR(&BLFD  )  TYPE(*CHAR) LEN(1)                                  /*BG1364*/
             DCL        VAR(&BLSY  )  TYPE(*CHAR) LEN(1)
             DCL        VAR(&STRRRN) TYPE(*DEC) LEN(10 0)                              /*MD020205A*/
             DCL        VAR(&ENDRRN) TYPE(*DEC) LEN(10 0)                              /*MD020205A*/

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
             DCL        VAR(&STM6)     TYPE(*CHAR) LEN(4) VALUE('''')                   /*MD055751*/
             DCL        VAR(&FSQLVIEW) TYPE(*CHAR) LEN(10) VALUE('GOFILE')              /*MD055751*/
             DCL        VAR(&OPNQRY2)  TYPE(*CHAR) LEN(1000)                            /*MD055751*/
                                                                                        /*MD055751*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             SNDPGMMSG  MSG('GOC0100 - Bulk Synchronisation of +
                          Global Layer:' *CAT &GPF) TOMSGQ(MRUNQ)

             RTVJOBA    TYPE(&JOBTYPE)

             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ')
             MONMSG     MSGID(CPF0000)

             CHGJOB SWS(00000000)

/* Get zone */

             CALL       PGM(GOGETZONE) PARM(&RTCD &ERMS &FULLCHECK +
                          &ZOZONE &ZOSHTC &ZORDNB &ZODNWD &ZOBCCY +
                          &ZONJOB)

/* error */
/**********  IF         COND(&RTCD *= '       ') THEN(DO)                           */ /*BUG18886 */
             IF         COND(&RTCD *NE '       ') THEN(DO)                             /*BUG18886 */
                GOTO       CMDLBL(ABNOR)
             ENDDO


/* Get synchronisation executables*/
/*********** CALL       PGM(GOGETSYNX) PARM(&GPF &ZOZONE &GLFU +      ******/             /*BG1364*/
/***********              &ZLFOVR &GLFOVR &GLFCLO &ZLFDLO &GLFDLO +   ******/             /*BG1364*/
/**********               &OPNQRY &BLSY)                              ******/             /*BG1364*/

/**********  CALL       PGM(GOGETSYNX) PARM(&GPF &ZOZONE &GLFU +     */                 /*MD055146*/
/**********               &ZLFOVR &GLFOVR &GLFCLO &ZLFDLO &GLFDLO +  */                 /*MD055146*/
/**********               &OPNQRY &ZLF &BLFD &BLSY)                  */      /*BG1364*/ /*MD055146*/
                                                                                        /*MD055146*/
/**********  CALL       PGM(GOGETSYNX) PARM(&GPF &ZOZONE &GLFU       */                 /*MD055751*/
/**********               &ZLFOVR &GLFOVR &GLFCLO &ZLFDLO &GLFDLO +  */                 /*MD055751*/
/**********               &OPNQRY &ZLF &BLFD &BLSY &GFGPF &GFGBRC +  */                 /*MD055751*/
/**********               &GFGLF)                                    */    /*MD055146*/ /*MD055751*/
                                                                                        /*MD055146*/
             CALL       PGM(GOGETSYNX) PARM(&GPF &ZOZONE &GLFU +
                          &ZLFOVR &GLFOVR &GLFCLO &ZLFDLO &GLFDLO +
                          &OPNQRY &ZLF &BLFD &BLSY &GFGPF &GFGBRC +
                          &GFGLF &FSQLVIEW &OPNQRY2)                                    /*MD055751*/
                                                                                        /*MD055751*/
/* End if bulk synchronisation not done for this file*/
/**********  IF         COND(&BLSY *= 'Y') THEN(DO)                                 */ /*BUG18886 */
             IF         COND(&BLSY *NE 'Y') THEN(DO)                                   /*BUG18886 */
              SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Bulk +
                            synchronisation was not done for file ' +
                            *CAT &GPF) TOPGMQ(*EXT)
             GOTO       CMDLBL(END)
             ENDDO

/* Generate Fix Data */
             CALL       PGM(GPC0010) PARM(&ZOZONE &GPF)

/* Generate Key Data */
             CALL       PGM(GPC0012) PARM(&ZOZONE &GPF &GLFU)

/* Bulk synchronisation program */
             CHGVAR     VAR(&PGM) VALUE('GO' *CAT %SST(&GPF 3 8))

/* Do bulk synchronisation */
             CALL       PGM(QCMDEXC) PARM(&ZLFOVR 60)
                                                                                        /*MD055146*/
             IF         COND(&GFGBRC *EQ ' ') THEN(DO)                                  /*MD055146*/
                                                                                        /*MD055146*/
             CALL       PGM(QCMDEXC) PARM(&GLFOVR 60)
/**********  CALL       PGM(QCMDEXC) PARM(&OPNQRY 5000)                                */ /*242731*/
/**********  CALL       PGM(QCMDEXC) PARM(&OPNQRY 32767)                    */ /*242731*/ /*243724*/
             CALL       PGM(QCMDEXC) PARM(&OPNQRY 32702)                                  /*243724*/
                                                                                        /*MD055146*/
             ENDDO                                                                      /*MD055146*/
             ELSE       CMD(DO)                                                         /*MD055146*/
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
/**********  CHGVAR     VAR(&STM_STR2) VALUE(&STM2 *CAT &GFGBRC *CAT + */               /*MD055751*/
/**********               &STM3 *CAT 'A8BRCD' *CAT &STM4 *CAT +        */               /*MD055751*/
/**********               'GZSDBRCHPD' *CAT &STM5)                     */  /*MD055146*/ /*MD055751*/
                                                                                        /*MD055751*/
                                                                                        /*MD055146*/
             CHGVAR     VAR(&STM_STR2) VALUE(&STM2 *CAT &GFGBRC *CAT +
                          &STM3 *CAT 'A8BRCD' *CAT &STM4 *CAT +
                          'GZSDBRCHPD')                                                 /*MD055751*/
                                                                                        /*MD055751*/
             CHGVAR     VAR(&STM_STR3) VALUE(&STM2 *CAT 'A8ZONE = ' +
                          *CAT &STM6 *TCAT %TRIMR(&ZOZONE) *TCAT &STM6  +
                          *CAT &STM5)                                                   /*MD055751*/
                                                                                        /*MD055751*/
                                                                                        /*MD055146*/
             CALL       PGM(UTWRTSQL2) PARM(&STM_STR1 &STM_STR2 +
                          &STM_STR3 '*WRITE')                                           /*MD055146*/
             RUNSQLSTM  SRCFILE(QTEMP/RUNSQL) SRCMBR(RUNSQLSTM) +
                          COMMIT(*NONE)                                                 /*MD055146*/
             MONMSG     MSGID(SQL9010)                                                  /*MD055751*/
                                                                                        /*MD055146*/
/**********  OVRDBF     FILE(GOFILE) TOFILE(&GFGLF) SHARE(*YES) +      */               /*MD055751*/
/**********               OPNSCOPE(*JOB)                               */  /*MD055146*/ /*MD055751*/
                                                                                        /*MD055146*/
                                                                                        /*MD055751*/
             CALL       PGM(QCMDEXC) PARM(&OPNQRY2 1000)                                /*MD055751*/
                                                                                        /*MD055751*/
             OVRDBF     FILE(&GFGLF) TOFILE(GOFILE) +
                          SHARE(*YES) OPNSCOPE(*JOB)                                    /*MD055751*/
                                                                                        /*MD055751*/
             ENDDO                                                                      /*MD055146*/
                                                                                        /*MD055146*/
                                                                                        /*MD055146*/
/**********  OVRDBF     FILE(&GPF) SEQONLY(*YES 5000) */                                  /*CLE041*/
             OVRDBF     FILE(&GPF) SEQONLY(*YES 4000)                                     /*CLE041*/
             OVRDBF     FILE(GPGDRPPD) SEQONLY(*YES 5000)
/* Filter duplicates                                                                  */  /*BG1364*/
             IF (&BLFD = 'Y') THEN(DO)                                                    /*BG1364*/
             OPNQRYF    FILE((&ZLF)) OPTION(*INP) KEYFLD(*FILE) +
                          UNIQUEKEY(*ALL) SEQONLY(*YES 5000)                              /*BG1364*/
             ENDDO                                                                        /*BG1364*/
                                                                                       /*MD020205A*/
             IF         COND(&PGM = 'GOSDACUSPD') THEN(DO)                             /*MD020205A*/
             RTVMBRD    FILE(SDACUSPD) NBRCURRCD(&ENDRRN)                              /*MD020205A*/
             CHGVAR     VAR(&STRRRN) VALUE(1)                                          /*MD020205A*/
             CALL       PGM(&PGM) PARM(&ZOZONE &STRRRN &ENDRRN)                        /*MD020205A*/
             ENDDO                                                                     /*MD020205A*/
             ELSE       CMD(DO)                                                        /*MD020205A*/
             CALL       PGM(&PGM) PARM(&ZOZONE)
             ENDDO                                                                     /*MD020205A*/
/**********  CALL       PGM(QCMDEXC) PARM(&GLFCLO 60)                */                 /*MD055146*/
             CALL       PGM(QCMDEXC) PARM(&ZLFDLO 60)
/**********  CALL       PGM(QCMDEXC) PARM(&GLFDLO 60)                */                 /*MD055146*/
                                                                                        /*MD055146*/
             IF         COND(&GFGBRC *EQ ' ') THEN(DO)                                  /*MD055146*/
             CALL       PGM(QCMDEXC) PARM(&GLFCLO 60)                                   /*MD055146*/
             CALL       PGM(QCMDEXC) PARM(&GLFDLO 60)                                   /*MD055146*/
             ENDDO                                                                      /*MD055146*/
             ELSE       CMD(DO)                                                         /*MD055146*/
/**********  DLTOVR     FILE(GOFILE)                                 */    /*MD055146*/ /*MD055751*/
             CLOF       OPNID(GOFILE)                                                   /*MD055751*/
             DLTOVR     FILE(&GFGLF)                                                    /*MD055751*/
             ENDDO                                                                      /*MD055146*/
                                                                                        /*MD055146*/

/* Log Global Totals */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
             CALL       PGM(GPC0011) PARM(&GPF)
             ENDDO

/*error*/
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                IF         COND(&JOBTYPE = '0') THEN(DO)
                   SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                                GOC0100 ended abnormally - see job log') +
                                TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(END)
                ENDDO

                IF         COND(&JOBTYPE = '1') THEN(DO)
                   SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                              TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                   GOTO       CMDLBL(END)
                ENDDO
             ENDDO

             GOTO       CMDLBL(END)

 ABNOR:

             CHGJOB     SWS(XXXXXX11)

             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)

/* Abnormal termination - batch job */

             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            GOC0100 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO

/* Abnormal termination - interactive job */

             IF         COND(&JOBTYPE = '1') THEN(DO)
                SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          GOC0100 ended abnormally - see job log') +
                          TOPGMQ(*EXT)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO

END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDPGM
