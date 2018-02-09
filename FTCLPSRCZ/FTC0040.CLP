/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT Outgoing Payments Maint. Level 1')           */
/*********************************************************************/
/*                                                                   */
/*       Midas       FUNDS TRANSFER MODULE                       */
/*                                                                   */
/*       FTC0040    OUTGOING PAYMENTS - LEVEL ONE                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC022             Date 24Feb04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      042167             Date 15Apr93              */
/*                      E23411            DATE  06SEP90             */
/*                      S01194            DATE  16AUG90             */
/*                      E29834            DATE  16AUG90             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC022 - Commitment Control Changes for MidasPlus           */
/*    042167 - CL PROGRAM FOR RECORD LOCKING                         */
/*    E23411 - MMOD WAS CHECKED IN POSITION 3 TO SEE IF RETAIL 1     */
/*             WAS SWITCHED ON.  THIS IS NOW OBSOLETE AND MMOD       */
/*             SHOULD BE CHECKED IN POSITIONS 16 AND 23 FOR          */
/*             RETAIL 2 AND INTEREST ON ACCOUNTS.                    */
/*    S01194 - NEW DATABASE HANDLING                                 */
/*    E29834 - NO ROLLBACK ISSUED IF DB ERROR                        */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SORT &PREF &RTCD)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&SORT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(15) /* Payment +
                          reference. */
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(1)
/*/COPY WNCPYSRC,FTC0040001                                          */
/**/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
/*           DCL        VAR(&MEM)   TYPE(*CHAR)   LEN(44)    */      /*S01194*/
             DCL        VAR(&MEM)   TYPE(*CHAR)   LEN(50)            /*S01194*/
                                                                      /*042167*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)               /*042167*/
             DCL        VAR(&MODULE) TYPE(*CHAR) LEN(2)               /*042167*/
             DCL        VAR(&TRNREF) TYPE(*CHAR) LEN(15)              /*042167*/
             DCL        VAR(&RINFOR) TYPE(*CHAR) LEN(80)              /*042167*/
 
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
                                                                                          /*CSC022*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
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
/**/
/** Retail II module in system **/
/**/
/*           IF         COND((%SUBSTRING(&MMOD 3 1) *EQ 'Y') *AND +
                          (%SUBSTRING(&MMOD 16 1) *EQ 'Y')) THEN(DO)/*E23411*/
/*E23411*/
             IF         COND((%SUBSTRING(&MMOD 16 1) = 'Y') +
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
             CHGJOB SWS(XXXXXX00)
/**/
/** Call program & monitor for untrapped errors **/
/**/
/*/COPY WNCPYSRC,FTC0040002                                          */
             CALL       PGM(FT0040) PARM(&SORT &PREF &RTCD)
/*/COPY WNCPYSRC,FTC0040003                                          */
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
/*/COPY WNCPYSRC,FTC0040005                                          */
                        SNDPGMMSG  MSG('Transaction Failed. +
                                        Re-input necessary. +
                                        Press Enter to Continue.') +
                                   TOPGMQ(*EXT)
/*/COPY WNCPYSRC,FTC0040007                                          */
                        GOTO FINISH
             ENDDO
/**/
/**   Database error handling   **/
/**/
             IF   COND(%SWITCH(XXXXXX11))   THEN(DO)
 /**/                                                                                     /*CSC022*/
 /** Execute rollback if SAR CSC022 is not enrolled or */                                 /*CSC022*/
 /**   job is not currently running in batch mode */                                      /*CSC022*/
 /**/                                                                                     /*CSC022*/
             IF         COND(&CSC022 *EQ 'N') THEN(DO)                                    /*CSC022*/
                        ROLLBACK                                     /*E29834*/
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
/*              RTVDTAARA   DTAARA(LDA (134 44))   RTNVAR(&MEM)      /*S01194*/
                RTVDTAARA   DTAARA(LDA (134 50))   RTNVAR(&MEM)      /*S01194*/
/*/COPY WNCPYSRC,FTC0040008                                          */
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                    TOPGMQ(*EXT) TOMSGQ(MOPERQ)
/*/COPY WNCPYSRC,FTC0040009                                          */
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/************FINISH: ENDPGM******************************************* *042167*/
FINISH:                                                               /*042167*/
/*/COPY WNCPYSRC,FTC0040004                                          */
/*/COPY WNCPYSRC,FTC0040006                                          */
/* */                                                                 /*042167*/
/* CALL AOC8000 to release locks */                                   /*042167*/
/* */                                                                 /*042167*/
             CHGVAR     VAR(&MODULE) VALUE('FT')                      /*042167*/
             CHGVAR     VAR(&TRNREF) VALUE('               ')         /*042167*/
             CHGVAR     VAR(&RINFOR) VALUE('    ')                    /*042167*/
             CHGVAR     VAR(&RTNCDE) VALUE('       ')                 /*042167*/
             CALL       PGM(AOC8000) PARM(&RTNCDE &MODULE &TRNREF +
                          &RINFOR)                                    /*042167*/
/* */
             ENDPGM                                                   /*042167*/
/**/
