/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT Payments authorisation')                     */
/*********************************************************************/
/*                                                                   */
/*        Midas - FUNDS TRANSFER MODULE                              */
/*                                                                   */
/*       FTC0060    PAYMENT AUTHORISATION AND ENQUIRY                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CRE020             Date 20Jan04              */
/*       Prev Amend No. CSC022             Date 24Feb04              */
/*                      CSC023             Date 29Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      110242             Date 07Nov96              */
/*                         084923              DATE 13APR95          */
/*                         042167              DATE 15MAR93          */
/*                         E23411              DATE 06SEP90          */
/*                         S01117              DATE 30AUG90          */
/*                         S01194              DATE 09JUL90          */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CRE020 - Midas Plus Online Printing of Advices (GE7)        */
/*       CSC022 - Commitment Control Changes for MidasPlus           */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*    110242 - Change defaults for SBMJOB cmd to take *JOBD          */
/*    084923 - If Auto Pay Receive generation is in effect, send a   */
/*             'MIDAS' message to MSTATUS to balance with MIDASRMV   */
/*             CALL, which otherwise removes a message sent by       */
/*             another job                                           */
/*    042167 - CL PROGRAM FOR RECORD LOCKING                         */
/*    E23411 - MMOD WAS CHECKED IN POSITION 3 TO SEE IF RETAIL 1     */
/*             WAS SWITCHED ON.  THIS IS NOW OBSOLETE AND MMOD       */
/*             SHOULD BE CHECKED IN POSITIONS 16 AND 23 FOR          */
/*             RETAIL 2 AND INTEREST ON ACCOUNTS.                    */
/*    S01117 - MULTIBRANCHING INCORPORATION                          */
/*    S01194 - NEW DATABASE ERROR HANDLINGG                          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PREF &RETC)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*           DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)        */      /*S01194*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                /*S01194*/
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(15)
             DCL        VAR(&RETC) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CMD)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
                                                                      /*042167*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)               /*042167*/
             DCL        VAR(&MODULE) TYPE(*CHAR) LEN(2)               /*042167*/
             DCL        VAR(&TRNREF) TYPE(*CHAR) LEN(15)              /*042167*/
             DCL        VAR(&RINFOR) TYPE(*CHAR) LEN(80)              /*042167*/
                                                                                          /*CRE020*/
/* Declare the variables to check the enhancements file */                                /*CRE020*/
                                                                                          /*CRE020*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                                                /*CRE020*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                     /*CRE020*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                                    /*CRE020*/
             DCL        VAR(&CRE020) TYPE(*CHAR) LEN(1) +
                          VALUE(' ')                                                      /*CRE020*/
                                                                                          /*CRE020*/
/*/COPY WNCPYSRC,FTC0060001                                          */
                                                                      /*042167*/
/*           DCLF       FILE(TABTB11)                        */      /*S01194*/
             DCLF       FILE(SDFTFRPD)                               /*S01194*/
                                                                                          /*CSC022*/
             DCL        VAR(&JBNM) TYPE(*CHAR) LEN(10)                                    /*CSC022*/
             DCL        VAR(&SCCMTJOB) TYPE(*CHAR) LEN(256)                               /*CSC022*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CSC022*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                                      /*CSC022*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CSC022*/
             DCL        VAR(&CSC022) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CSC022*/
             DCL        VAR(&CMTNUM) TYPE(*DEC) LEN(3 0)                                  /*CSC022*/
             DCL        VAR(&CMTJOB1) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB2) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB3) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB4) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB5) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB6) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB7) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB8) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB9) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB10) TYPE(*CHAR) LEN(10)                                /*CSC022*/
             DCL        VAR(&CRSKIP) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CSC022*/
                                                                                          /*CSC022*/
             CHGVAR     VAR(&CSC022) VALUE('N')                                           /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('N')                                           /*CSC022*/
             CHGVAR     VAR(&RTNCDE) VALUE('       ')                                     /*CSC022*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CSC022*/
             CHGVAR     VAR(&SAR) VALUE('CSC022')                                         /*CSC022*/
                                                                                          /*CSC022*/
 /**/                                                                                     /*CSC022*/
 /** Call AO Switchable features  */                                                      /*CSC022*/
 /**/                                                                                     /*CSC022*/
             CALL       PGM(AOSARDR0) PARM(&RTNCDE &OPTN &SAR &SCSARD)                    /*CSC022*/
                                                                                          /*CSC022*/
             IF         COND(&RTNCDE *EQ '       ') THEN(DO)                              /*CSC022*/
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
                                                                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
                                                                                          /*CRE020*/
/* Check if enhancement CRE020 in installed */                                            /*CRE020*/
                                                                                          /*CRE020*/
             CHGVAR     VAR(&SARD) VALUE('CRE020')                                        /*CRE020*/
             CALL       PGM(AOSARDR0) PARM(&RTNCDE &OPTN &SARD &FMT)                      /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&RTNCDE *NE '       ' *AND &RTNCDE *NE +
                          '*NRF   ') THEN(GOTO CMDLBL(END))                               /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&RTNCDE *EQ '       ') THEN(CHGVAR +
                          VAR(&CRE020) VALUE('Y'))                                        /*CRE020*/
/**/
/*/COPY WNCPYSRC,FTC0060002                                          */
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
/**/
/** Retail II module in system **/
/**/
/*           IF         COND((%SUBSTRING(&MMOD 3 1) *EQ 'Y') *AND +
                          (%SUBSTRING(&MMOD 16 1) *EQ 'Y')) THEN(DO)  /*23411*/
/*E23411*/
             IF COND((%SUBSTRING(&MMOD 16 1) = 'Y') +
             *OR (%SUBSTRING(&MMOD 23 1)) = 'Y') +
             THEN(DO)
/*E23411*/
                  CHGJOB SWS(1XXXXXXX)
             ENDDO
/**/
/** Dealing module in system **/
/**/
             IF  COND(%SUBSTRING(&MMOD 2 1) *EQ 'Y') THEN(DO)
                  CHGJOB SWS(X1XXXXXX)
             ENDDO
/**/
 
             CHGJOB     SWS(XXXXXX00)
 
/*  CALL PROGRAM & MONITOR FOR ERRORS                               */
 
             CALL       PGM(FT0060) PARM(&PREF &RETC)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
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
/*/COPY WNCPYSRC,FTC0060006                                          */
             SNDPGMMSG  MSG('Transaction Failed. Re-input necessary. +
                          Press Enter to Continue.') TOPGMQ(*EXT)
/*/COPY WNCPYSRC,FTC0060007                                          */
             GOTO       CMDLBL(END)
             ENDDO
/*/COPY WNCPYSRC,FTC0060010                                          */
/* AUTOMATIC CALL OF PAY/RECEIVE INDICATOR - ONLY IF NOT LINKED */
/**/
             IF         COND(&PREF *EQ ' ') THEN(DO)
/**/
/*           RCVF       RCDFMT(TABTB11F)                    */      /*S01194*/
             RCVF       RCDFMT(SDFTFRD0)                            /*S01194*/
/*           IF         COND((&APYR = 'Y')) THEN(DO)        */      /*S01194*/
             IF         COND((&BTAFTM = 'Y')) THEN(DO)              /*S01194*/
/*           RTVDTAARA  DTAARA(LDA (178 1))   RTNVAR(&CMD)  */      /*S01194*/
             RTVDTAARA  DTAARA(LDA (184 1))   RTNVAR(&CMD)          /*S01194*/
/**/
             IF         COND((&CMD = '3')) THEN(DO)
/**/                                                                /*084923*/
             SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)                /*084923*/
/*/COPY WNCPYSRC,FTC0060004                                          */
/**/
/*           SBMJOB     JOB(FTC0630) JOBD(MBATCH) RTGDTA(*JOBD) +*/  /*S01117*/
/*                        RQSDTA('CALL PGM(FTC0630)')   */           /*S01117*/
/************SBMJOB     JOB(FTC0630) JOBD(MBATCH) RTGDTA(*JOBD) +     /*110242*/
/*************      RQSDTA('CALL PGM(FTC0630) PARM('''' '''' '''' +   /*110242*/
/*************            )') */                              /*S01117  110242*/
/************SBMJOB     JOB(FTC0630) JOBD(MBATCH) RTGDTA(*JOBD) +                         /*CPK014*/
/************             RQSDTA('CALL PGM(FTC0630) PARM('''' '''' +                      /*CPK014*/
/************             '''' )') INLLIBL(*JOBD)                     /*110242*/          /*CPK014*/
/************SBMJOB     CMD(CALL PGM(MIDASRMV)) JOB(MIDASRMV) +                           /*CPK014*/
/************             JOBD(MBATCH) RTGDTA(*JOBD) INLLIBL(*JOBD)   /*S01117*/          /*CPK014*/
/************SBMJOB     JOB(FTC0630) JOBD(MBATCH) USER(*JOBD) +                           /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL PGM(FTC0630) +                       /*CSC023*/
/************             PARM('''' '''' '''' )') INLLIBL(*JOBD)               /*CPK014*/ /*CSC023*/
/************SBMJOB     CMD(CALL PGM(MIDASRMV)) JOB(MIDASRMV) +                           /*CSC023*/
/************             JOBD(MBATCH) USER(*JOBD) RTGDTA(*JOBD) +                        /*CSC023*/
/************             INLLIBL(*JOBD)                                       /*CPK014*/ /*CSC023*/
             SBMJOB     JOB(FTC0630) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL PGM(FTC0630) +
                          PARM('''' '''' '''' )') INLLIBL(*JOBD) OUTQ(*JOBD)              /*CSC023*/
             SBMJOB     CMD(CALL PGM(MIDASRMV)) JOB(MIDASRMV) +
                          JOBD(MBATCH) USER(*JOBD) RTGDTA(*JOBD) +
                          INLLIBL(*JOBD) OUTQ(*JOBD)                                      /*CSC023*/
/*/COPY WNCPYSRC,FTC0060003                                          */
             ENDDO
             ENDDO
/**/
             ENDDO
/**/
 
/**   DATABASE ERROR HANDLING   **/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
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
/*           RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)    */      /*S01194*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)            /*S01194*/
/*/COPY WNCPYSRC,FTC0060008                                          */
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
/*/COPY WNCPYSRC,FTC0060009                                          */
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*END:********ENDPGM****/                                             /*042167*/
 
/**/                                                                  /*042167*/
/* CALL AOC8000 to release locks */                                   /*042167*/
/* */                                                                 /*042167*/
END:         CHGVAR     VAR(&MODULE) VALUE('FT')                      /*042167*/
             CHGVAR     VAR(&TRNREF) VALUE('               ')         /*042167*/
             CHGVAR     VAR(&RINFOR) VALUE('    ')                    /*042167*/
             CHGVAR     VAR(&RTNCDE) VALUE('       ')                 /*042167*/
             CALL       PGM(AOC8000) PARM(&RTNCDE &MODULE &TRNREF +
                          &RINFOR)                                    /*042167*/
/*/COPY WNCPYSRC,FTC0060005                                          */
/**/                                                                  /*042167*/
                                                                                          /*CRE020*/
          IF         COND((%SWITCH(XXXXXX00)) +
                     *AND (&CRE020 = 'Y')) THEN(DO)                                       /*CRE020*/
             SBMJOB     JOB(REC000881) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL   REC000881 +
                          (FT0060 FT)') INLLIBL(*JOBD) MSGQ(MOPERQ)                       /*CRE020*/
                ENDDO                                                                     /*CRE020*/
                                                                                          /*CRE020*/
             ENDPGM                                                   /*042167*/
 
