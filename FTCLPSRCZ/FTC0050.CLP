/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT Incoming payments maint. level 1')           */
/********************************************************************/
/*                                                                  */
/*        Midas     - FUNDS TRANSFER MODULE                     */
/*                                                                  */
/*       FTC0050  - CL COMPONENT TO CONTROL FT0050                  */
/*                  INCOMING PAYMENTS MAINTENANCE.                  */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC022             Date 24Feb04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01435            DATE  22JUL93             */
/*                      S01428            DATE  27JUN93             */
/*                      042167            DATE  15APR93             */
/*                      S01259            DATE  11NOV91             */
/*                      S01194            DATE  11JUL90             */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       CSC022 - Commitment Control Changes for MidasPlus           */
/*       S01435  -  Incoming Message Management.                    */
/*       S01428  -  Remove any unprocessed Reserved Electronic      */
/*                  messages for the current job                    */
/*       042167  -  CL PROGRAM FOR RECORD LOCKING                   */
/*       S01259  -  SWIFT II CHANGES                                */
/*       S01194  -  STANDING DATA CHANGES                           */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&SORT &PREF &RTCD &WLINK)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/************DCL        VAR(&DATA) TYPE(*CHAR) LEN(44)               /*S01194*/
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)               /*S01194*/
             DCL        VAR(&SORT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(15) /* Payment +
                          reference. */
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WLINK) TYPE(*CHAR) LEN(1)
                                                                      /*042167*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)               /*042167*/
             DCL        VAR(&MODULE) TYPE(*CHAR) LEN(2)               /*042167*/
             DCL        VAR(&TRNREF) TYPE(*CHAR) LEN(15)              /*042167*/
             DCL        VAR(&RINFOR) TYPE(*CHAR) LEN(80)              /*042167*/
                                                                      /*042167*/
             DCL        VAR(&EMACT) TYPE(*CHAR) LEN(7)                /*S01428*/
             DCL        VAR(&EMMOR) TYPE(*CHAR) LEN(28)              /*S01428*/
             DCL        VAR(&EMMIR) TYPE(*CHAR) LEN(28)              /*S01428*/
             DCL        VAR(&EMRTN) TYPE(*CHAR) LEN(7)               /*S01428*/
             DCL        VAR(&EMMSGR) TYPE(*DEC) LEN(8 0)             /*S01435*/
             DCL        VAR(&EMPART) TYPE(*DEC) LEN(3 0)             /*S01435*/
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
/*/COPY WNCPYSRC,FTC0050003                                          */
 
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
             CHGJOB     SWS(XXXXXX00)
/**/
/** Call program & monitor for untrapped errors **/
/**/
/************OVRDBF     FILE(MSIME) SHARE(*NO)                       /*S01259*/
             OVRDBF     FILE(MSMSI2L9) SHARE(*NO)                    /*S01259*/
/*/COPY WNCPYSRC,FTC0050002                                          */
             CALL       PGM(FT0050) PARM(&SORT &PREF &RTCD &WLINK)
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
/*/COPY WNCPYSRC,FTC0050005                                          */
                        SNDPGMMSG  MSG('Transaction Failed. +
                                        Re-input necessary. +
                                        Press Enter to Continue.') +
                                   TOPGMQ(*EXT)
/*/COPY WNCPYSRC,FTC0050006                                          */
                        GOTO END
/*/COPY WNCPYSRC,FTC0050001                                          */
             ENDDO
/**/
/** Check for database errors trapped by program **/
/**/
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
 /**************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&DATA)        /*S01194*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)        /*S01194*/
/*/COPY WNCPYSRC,FTC0050007                                          */
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
/*/COPY WNCPYSRC,FTC0050008                                          */
             ENDDO
 
/************DLTOVR     FILE(MSIME)                                  /*S01259*/
             DLTOVR     FILE(MSMSI2L9)                               /*S01259*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*END:*********ENDPGM**********                                       /*042167*/
END:                                                                  /*042167*/
/* */                                                                 /*042167*/
/* CALL AOC8000 to release locks */                                   /*042167*/
/* */                                                                 /*042167*/
             CHGVAR     VAR(&MODULE) VALUE('FT')                      /*042167*/
             CHGVAR     VAR(&TRNREF) VALUE('               ')         /*042167*/
             CHGVAR     VAR(&RINFOR) VALUE('    ')                    /*042167*/
             CHGVAR     VAR(&RTNCDE) VALUE('       ')                 /*042167*/
             CALL       PGM(AOC8000) PARM(&RTNCDE &MODULE &TRNREF +
                          &RINFOR)                                    /*042167*/
/* */                                                                 /*042167*/
/* CALL FTEMSGU0 to remove any remaining reserved electronic msgs*/   /*S01428*/
/* */                                                                 /*S01428*/
 /**/                                                                                     /*CSC022*/
 /** Execute rollback if SAR CSC022 is not enrolled or */                                 /*CSC022*/
 /**   job is not currently running in batch mode */                                      /*CSC022*/
 /**/                                                                                     /*CSC022*/
             IF         COND(&CSC022 *EQ 'N') THEN(DO)                                    /*CSC022*/
             ROLLBACK                                                 /*S01428*/
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
             CHGVAR     VAR(&EMACT) VALUE('*END   ')                  /*S01428*/
             CHGVAR     VAR(&EMMOR) +
                          VALUE('                            ')       /*S01428*/
             CHGVAR     VAR(&EMMIR) +
                          VALUE('                            ')       /*S01428*/
             CHGVAR     VAR(&EMRTN) VALUE('       ')                  /*S01428*/
             CHGVAR     VAR(&EMMSGR) VALUE(0)                         /*S01435*/
             CHGVAR     VAR(&EMPART) VALUE(0)                         /*S01435*/
/*           CALL       PGM(FTEMSGU0) PARM(&EMACT &EMMOR &EMMIR +       S01435*/
/*                        &EMRTN)                               *S01428*S01435*/
             CALL       PGM(ME1070) PARM(&EMACT &EMMSGR &EMPART +
                          &EMMOR &EMMIR &EMRTN)                       /*S01435*/
 /**/                                                                                     /*CSC022*/
 /** Execute commit if SAR CSC022 is not enrolled or */                                   /*CSC022*/
 /**   job is not currently running in batch mode */                                      /*CSC022*/
 /**/                                                                                     /*CSC022*/
             IF         COND((&CSC022 *EQ 'N') *OR ((&CSC022 *EQ 'Y' +
                          *AND &CRSKIP *EQ 'N'))) THEN(DO)                                /*CSC022*/
             COMMIT                                                   /*S01428*/
             ENDDO                                                                        /*CSC022*/
/* */
             ENDPGM                                                   /*042167*/
