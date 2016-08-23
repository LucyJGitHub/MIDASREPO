/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT Cheque printing - input cycle')              */
/*********************************************************************/
/*                                                                   */
/*       Midas      FUNDS TRANSFER MODULE                        */
/*                                                                   */
/*       FTC0580    CHEQUE PRINTING - INPUT CYCLE                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. CRE026             Date 24May06              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CFT118             Date 24Aug04              */
/*                      CSC022             Date 24Aug04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      205448             Date 02May02              */
/*                      CCG015             Date 09Aug01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date  15Nov96             */
/*                                                                   */
/*                      S01117             Date  16Apr91             */
/*                      S01194         DATE  16APR91                 */
/*                                                                   */
/*********************************************************************/
/*    CRE026 - Consumer Banking (Recompile)                          */
/*    CFT118 - Core changes for GBO018. Demand Drafts Printing.      */
/*           - Added hooks FTC0580008 and FTC0580009                 */
/*           - Added hooks FTC0580010 and FTC0580011                 */
/*           - Amended hook FTC0580002                               */
/*           - Amended hook FTC0580003                               */
/*           - Amended hook FTC0580006                               */
/*    CSC022 - Commitment Control Changes for MidasPlus              */
/*    205448 - UDC module must be on for Correspondence Manager      */
/*    CCG015 - Correspondence Manager Phase 1                        */
/*    S01408 - Addition of core hook FTC0580005                      */
/*             Addition of core hook FTC0580004                      */
/*             Addition of core hook FTC0580003                      */
/*             Addition of core hook FTC0580002                      */
/*             Addition of core hook FTC0580001                      */
/*    S01194 - NEW DATABASE HANDLING                                 */
/*    S01117 - RELEASE 10 MULTIBRANCHING CHANGES                     */
/*********************************************************************/
/*/COPY WNCPYSRC,FTC0580008                                                               /*CFT118*/
       PGM
/*/COPY WNCPYSRC,FTC0580009                                                               /*CFT118*/
 
        DCLF       FILE(MUSERDD)                                      /*S01117*/
        DCL    VAR(&RTCD)  TYPE(*CHAR)   LEN(7)                       /*205448*/
        DCL    VAR(&OPTN)  TYPE(*CHAR)   LEN(7)                       /*205448*/
        DCL    VAR(&FMT)   TYPE(*CHAR)   LEN(200)                     /*205448*/
/**     DCL    VAR(&DATA)  TYPE(*CHAR)   LEN(45)                      /*S01194*/
        DCL    VAR(&DATA)  TYPE(*CHAR)   LEN(50)                      /*S01194*/
        DCL    VAR(&MBIN)  TYPE(*CHAR)   LEN(1)                       /*S01117*/
        DCL    VAR(&USER)  TYPE(*CHAR)   LEN(10)                      /*S01117*/
        DCL    VAR(&AOUTQ) TYPE(*CHAR)   LEN(10) VALUE('*JOB      ')  /*S01117*/
                                                                                          /*CSC022*/
        DCL    VAR(&JBNM) TYPE(*CHAR) LEN(10)                                             /*CSC022*/
        DCL    VAR(&SCCMTJOB) TYPE(*CHAR) LEN(256)                                        /*CSC022*/
        DCL    VAR(&OPTN) TYPE(*CHAR) LEN(7)                                              /*CSC022*/
        DCL    VAR(&SAR) TYPE(*CHAR) LEN(6)                                               /*CSC022*/
        DCL    VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                          /*CSC022*/
        DCL    VAR(&CSC022) TYPE(*CHAR) LEN(1) VALUE(' ')                                 /*CSC022*/
        DCL    VAR(&CMTNUM) TYPE(*DEC) LEN(3 0)                                           /*CSC022*/
        DCL    VAR(&CMTJOB1) TYPE(*CHAR) LEN(10)                                          /*CSC022*/
        DCL    VAR(&CMTJOB2) TYPE(*CHAR) LEN(10)                                          /*CSC022*/
        DCL    VAR(&CMTJOB3) TYPE(*CHAR) LEN(10)                                          /*CSC022*/
        DCL    VAR(&CMTJOB4) TYPE(*CHAR) LEN(10)                                          /*CSC022*/
        DCL    VAR(&CMTJOB5) TYPE(*CHAR) LEN(10)                                          /*CSC022*/
        DCL    VAR(&CMTJOB6) TYPE(*CHAR) LEN(10)                                          /*CSC022*/
        DCL    VAR(&CMTJOB7) TYPE(*CHAR) LEN(10)                                          /*CSC022*/
        DCL    VAR(&CMTJOB8) TYPE(*CHAR) LEN(10)                                          /*CSC022*/
        DCL    VAR(&CMTJOB9) TYPE(*CHAR) LEN(10)                                          /*CSC022*/
        DCL    VAR(&CMTJOB10) TYPE(*CHAR) LEN(10)                                         /*CSC022*/
        DCL    VAR(&CRSKIP) TYPE(*CHAR) LEN(1) VALUE(' ')                                 /*CSC022*/
        DCL   VAR(&ACTION) TYPE(*CHAR) LEN(8)                                             /*CCG015*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*/COPY WNCPYSRC,FTC0580006                                          */
/**/                                                                  /*S01117*/
/** GLOBAL MONITOR MESSAGE   **/
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
/**/                                                                  /*S01117*/
       CHGJOB     SWS(XXXXXX00)
                                                                                          /*CSC022*/
             CHGVAR     VAR(&CSC022) VALUE('N')                                           /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('N')                                           /*CSC022*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CSC022*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CSC022*/
             CHGVAR     VAR(&SAR) VALUE('CSC022')                                         /*CSC022*/
 /**/                                                                                     /*CSC022*/
 /** Call AO Switchable features  */                                                      /*CSC022*/
 /**/                                                                                     /*CSC022*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CSC022*/
                                                                                          /*CSC022*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CSC022*/
             CHGVAR     VAR(&CSC022) VALUE('Y')                                           /*CSC022*/
             RTVDTAARA  DTAARA(SCCMTJOB (1 256)) RTNVAR(&SCCMTJOB)                        /*CSC022*/
             CHGVAR     VAR(&CMTNUM) VALUE(%SST(&SCCMTJOB 1 3))                           /*CSC022*/
             CHGVAR     VAR(&CMTJOB1) VALUE(%SST(&SCCMTJOB 4 10))                         /*CSC022*/
             CHGVAR     VAR(&CMTJOB2) VALUE(%SST(&SCCMTJOB 14 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB3) VALUE(%SST(&SCCMTJOB 24 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB4) VALUE(%SST(&SCCMTJOB 34 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB5) VALUE(%SST(&SCCMTJOB 44 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB6) VALUE(%SST(&SCCMTJOB 54 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB7) VALUE(%SST(&SCCMTJOB 64 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB8) VALUE(%SST(&SCCMTJOB 74 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB9) VALUE(%SST(&SCCMTJOB 84 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB10) VALUE(%SST(&SCCMTJOB 94 10))                       /*CSC022*/
                                                                                          /*CSC022*/
             IF         COND((&CMTNUM *GT 0) *AND (&CMTJOB1 *EQ +
                          &JBNM)) THEN(DO)                                                /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 1) *AND (&CMTJOB2 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 2) *AND (&CMTJOB3 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 3) *AND (&CMTJOB4 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 4) *AND (&CMTJOB5 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 5) *AND (&CMTJOB6 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 6) *AND (&CMTJOB7 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 7) *AND (&CMTJOB8 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 8) *AND (&CMTJOB9 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 9) *AND (&CMTJOB10 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*205448*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                                       /*205448*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)                              /*205448*/
/* */                                                                                     /*205448*/
/** Database error handling                                                               /*205448*/
             IF         COND(&RTCD *NE '       ') THEN(DO)                                /*205448*/
                SNDPGMMSG  MSG('Unable to retrieve the Midas Modules +
                             list') TOPGMQ(*EXT) TOMSGQ(MOPERQ)                           /*205448*/
                GOTO ERROR                                                                /*205448*/
             ENDDO                                                                        /*205448*/
                                                                                          /*CCG015*/
/* UDC module must be on in order to call a Correspondence Manager program                /*205448*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)                           /*205448*/
/** Call Extract File Instance Management */                                              /*CCG015*/
                CHGVAR     VAR(&ACTION) VALUE('*PREPARE')                                 /*CCG015*/
                CALL       PGM(CGC3605) PARM(&ACTION)                                     /*CCG015*/
             ENDDO                                                                        /*205448*/
/**/                                                                  /*S01117*/
/** RETREIVE DATA AREA RUNDAT **/
/**/
             RTVDTAARA  DTAARA(RUNDAT (13 1)) RTNVAR(&MBIN)
/**/
      IF         COND(&MBIN *EQ 'Y') THEN(DO)
/**/
/*/COPY WNCPYSRC,FTC0580010                                                               /*CFT118*/
             RTVJOBA    USER(&USER)
/*/COPY WNCPYSRC,FTC0580011                                                               /*CFT118*/
READ:        RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ERROR))
             IF         COND(&USRP *NE &USER) THEN(GOTO CMDLBL(READ))
 
 /* CHECK FOR EXISTENCE OF CHEQUE OUTQ ON THE USER FILE */
 
             IF         COND(&COUTQ *EQ '          ') THEN(DO)
             SNDPGMMSG  MSG('Object "Cheque outq" on MUSERDD not +
                          found. Program ENDED ABNORMALLY') +
                          TOPGMQ(*EXT) TOMSGQ(*SYSOPR)
             GOTO END
               ENDDO
 
 /* CHECK THAT OUTQ DEFINED IS STILL VALID AND THAT USER HAS */
 /* AUTHORITY TO IT                                          */
 
             CHKOBJ     OBJ(&COUTQ) OBJTYPE(*OUTQ) AUT(*USE)
               MONMSG     MSGID(CPF9801) EXEC(DO)
             SNDPGMMSG  MSG('Object "Cheque outq" defined on MUSERDD +
                          does not exist on system. Program ENDED +
                          ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(*SYSOPR)
             GOTO END
               ENDDO
               MONMSG     MSGID(CPF9802) EXEC(DO)
             SNDPGMMSG  MSG('Not authorised to"Cheque outq" on +
                          MUSERDD. Program ENDED ABNORMALLY') +
                          TOPGMQ(*EXT) TOMSGQ(*SYSOPR)
             GOTO END
               ENDDO
             OVRPRTF    FILE(FT0580P1) OUTQ(&COUTQ)
             OVRPRTF    FILE(FT0580AU) OUTQ(&COUTQ)
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,FTC0580001                                           /*S01408*/
/**/                                                                  /*S01408*/
             CHGVAR     VAR(&AOUTQ) VALUE(&COUTQ)
/**/
      ENDDO                                                           /*S01117*/
/**/
/** call program & monitor for untrapped errors **/
/**/
/**    CALL       PGM(FT0580)                                         /*S01117*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,FTC0580002                                           /*S01408*/
/**/                                                                  /*S01408*/
       CALL       PGM(FT0580) PARM(&AOUTQ)                            /*S01117*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,FTC0580003                                           /*S01408*/
/**/                                                                  /*S01408*/
       MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
/* UDC module must be on in order to call a Correspondence Manager program                /*205448*/
                  IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)                      /*205448*/
                     CHGVAR     VAR(&ACTION) VALUE('*CLEAR  ')                            /*CCG015*/
                     CALL       PGM(CGC3605) PARM('&ACTION')                              /*CCG015*/
                  ENDDO                                                                   /*205448*/
 
 /**/                                                                                     /*CSC022*/
 /** Execute rollback if SAR CSC022 is not enrolled or */                                 /*CSC022*/
 /**   job is not currently running in batch mode */                                      /*CSC022*/
 /**/                                                                                     /*CSC022*/
             IF         COND(&CSC022 *EQ 'N') THEN(DO)                                    /*CSC022*/
                  ROLLBACK
             ENDDO                                                                        /*CSC022*/
             ELSE       CMD(DO)                                                           /*CSC022*/
             IF         COND(&CRSKIP *EQ 'N') THEN(DO)                                    /*CSC022*/
                        ROLLBACK                                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ELSE       CMD(DO)                                                           /*CSC022*/
                        CHGJOB     SWS(XXXXXX11)                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ENDDO                                                                        /*CSC022*/
                                                                                          /*CSC022*/
                  SNDPGMMSG  MSG('Transaction Failed. +
                                  Re-input necessary. +
                                  Press Enter to Continue.') +
                             TOPGMQ(*EXT)
                  GOTO END
       ENDDO
/**/
/** check for database errors trapped by program **/
/**/
       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**********       ROLLBACK                                           */                   /*CCG015*/
/**               RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&DATA)       /*S01194*/
                  RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)       /*S01194*/
                  SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                  GOTO CMDLBL(ERROR)                                                      /*CCG015*/
       ENDDO
                                                                                          /*CCG015*/
/** As opposed to the other CL the Merge Process (CGC3604) is called inside               /*CCG015*/
/** FT0580. This is done because FT0580 launches the print generator                      /*CCG015*/
                                                                                          /*CCG015*/
                  GOTO END                                            /*S01117*/
 
/*ERROR:***         ROLLBACK                                         */        /*S01117*/ /*CCG015*/
ERROR:                                                                                    /*CCG015*/
/* UDC module must be on in order to call a Correspondence Manager program                /*205448*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)                           /*205448*/
                CHGVAR     VAR(&ACTION) VALUE('*CLEAR  ')                                 /*CCG015*/
                CALL       PGM(CGC3605) PARM('&ACTION')                                   /*CCG015*/
             ENDDO                                                                        /*205448*/
 
 /**/                                                                                     /*CSC022*/
 /** Execute rollback if SAR CSC022 is not enrolled or */                                 /*CSC022*/
 /**   job is not currently running in batch mode */                                      /*CSC022*/
 /**/                                                                                     /*CSC022*/
             IF         COND(&CSC022 *EQ 'N') THEN(DO)                                    /*CSC022*/
             ROLLBACK                                                                     /*CCG015*/
             ENDDO                                                                        /*CSC022*/
             ELSE       CMD(DO)                                                           /*CSC022*/
             IF         COND(&CRSKIP *EQ 'N') THEN(DO)                                    /*CSC022*/
                        ROLLBACK                                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ELSE       CMD(DO)                                                           /*CSC022*/
                        CHGJOB     SWS(XXXXXX11)                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ENDDO                                                                        /*CSC022*/
                                                                                          /*CSC022*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,FTC0580004                                           /*S01408*/
/**/                                                                  /*S01408*/
             SNDPGMMSG  MSG('Program FT0580 - "Cheque printing" +
                          ENDED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(*SYSOPR)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**    END:         ENDPGM                                            /*S01117*/
END:                                                                  /*S01117*/
/**/                                                                  /*S01117*/
/** delete overrides **/                                              /*S01117*/
/**/                                                                  /*S01117*/
             DLTOVR     FILE(FT0580P1 FT0580AU)                       /*S01117*/
             MONMSG     MSGID(CPF9841)                                /*S01117*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,FTC0580005                                           /*S01408*/
/**/                                                                  /*S01408*/
        ENDPGM                                                        /*S01117*/
