/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE I/C Confirmation Reprint Prompt')            */
/********************************************************************/
/*                                                                   */
/*  Midas - Securities Trading Module                        */
/*                                                                   */
/*  SEC0308 - INPUT CYCLE TRADE CONFIRMATION REPRINT PROMPT          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01502             DATE 08JUL94              */
/*       PREV AMEND NO. S01117             DATE 10DEC90              */
/*                 S01271             DATE  08JUN90                  */
/*                 E19614             DATE  07DEC89                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       S01502 - BLI Telekurs Processing.  Recompiled due to        */
/*                change in length of SESTAT, 133 long.              */
/*  S01117 - Multibranching                                          */
/*  S01271 - PAY RECEIVE IN INPUT CYCLE - PREVENT FILE LOCKS         */
/*           WITH I/C PAY/RECEIVES  & OTHER CONFIRMATION             */
/*           PRINTS IN INPUT CYCLE .                                 */
/*  E19614 - Created for Reprint Trade Confirmations option.         */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM                                                     * *S01117*/
             PGM      PARM(&RSEQ &RLEV &RENT &RPARM &RACT &RCMD)      /*S01117*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
/*           DCL VAR(&MEM) TYPE(*CHAR) LEN(44)                     */ /*S01117*/
             DCL VAR(&MEM) TYPE(*CHAR) LEN(50)                        /*S01117*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*S01117*/
             DCL        VAR(&RACT) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RCMD) TYPE(*CHAR) LEN(1)                 /*S01117*/
/************DCL       VAR(&SESTAT)   TYPE(*CHAR)  LEN(128)*/  /*S01271 S01502*/
             DCL       VAR(&SESTAT)   TYPE(*CHAR)  LEN(133)           /*S01502*/
/**/
             DCL       VAR(&LDA)   TYPE(*CHAR)  LEN(256)
/* */                                                                 /*S01117*/
/** Global MONMSG to trap errors                                   */ /*S01117*/
/* */                                                                 /*S01117*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))                              /*S01117*/
/**/
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
/**/
             RTVDTAARA DTAARA(SESTAT) RTNVAR(&SESTAT)                 /*S01179*/
 
/*  CONFIRMATIONS CANNOT BE RUN IF THEY ARE ALREADY BEING      */     /*S01271*/
/*  PRINTED.                                                   */     /*S01271*/
                                                                      /*S01271*/
/*********** IF    COND(%SUBSTRING(&SESTAT 73 1) *EQ 'Y') +             S01117*/
/*********** THEN(+                                                     S01117*/
/***********    SNDPGMMSG  MSG('CONFIRMATIONS REPRINT REQUESTED +       S01117*/
/***********                    BUT CONFIRMATIONS ALREADY PRINTING') +  S01117*/
/***********               TOPGMQ(*EXT) MSGTYPE(*INFO))           S01271S01117*/
             IF    COND(%SUBSTRING(&SESTAT 73 1) *EQ 'Y') +
             THEN(DO)                                                 /*S01117*/
                SNDPGMMSG  MSG('CONFIRMATIONS REPRINT REQUESTED +
                                BUT CONFIRMATIONS ALREADY PRINTING') +
                           TOPGMQ(*EXT) MSGTYPE(*INFO)                /*S01117*/
             CHGVAR     VAR(&RCMD) VALUE('E')                         /*S01117*/
             ENDDO                                                    /*S01117*/
             ELSE DO                                                  /*S01271*/
                                                                      /*S01271*/
/*  CONFIRMATIONS CANNOT BE RUN IF PAY/RECEIVES ARE RUNNING    */     /*S01271*/
/*  AS FILES WILL NOT BE AVAILABLE.                            */     /*S01271*/
                                                                      /*S01271*/
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)                /*S01271*/
/*********** IF    COND(%SUBSTRING(&SESTAT 74 1) *EQ 'Y') +             S01117*/
/*********** THEN(+                                                     S01117*/
/*********** SNDPGMMSG  MSG('CONFIRMATIONS CANNOT BE RUN AS +           S01117*/
/***********                 PAY/RECEIVES ARE ACTIVE') +                S01117*/
/***********                 TOPGMQ(*EXT) MSGTYPE(*INFO))         S01271S01117*/
             IF    COND(%SUBSTRING(&SESTAT 74 1) *EQ 'Y') +
             THEN(DO)                                                 /*S01117*/
             SNDPGMMSG  MSG('CONFIRMATIONS CANNOT BE RUN AS +
                             PAY/RECEIVES ARE ACTIVE') +
                             TOPGMQ(*EXT) MSGTYPE(*INFO)              /*S01117*/
             CHGVAR     VAR(&RCMD) VALUE('E')                         /*S01117*/
             ENDDO                                                    /*S01117*/
                                                                      /*S01271*/
             ELSE DO                                                  /*S01271*/
                                                                      /*S01271*/
/*  ALLOCATE SESTAT, INDICATE CONFIRMATION PRINT IS ACTIVE  */        /*S01271*/
/*  AND THEN DEALLOCATE.                                    */        /*S01271*/
                                                                      /*S01271*/
             ALCOBJ     OBJ((SESTAT *DTAARA *EXCLRD))                 /*S01271*/
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)                /*S01271*/
             CHGVAR     VAR(%SUBSTRING(&SESTAT 73 1)) VALUE('Y')      /*S01271*/
             CHGDTAARA  DTAARA(SESTAT) VALUE(&SESTAT)                 /*S01271*/
             DLCOBJ     OBJ((SESTAT *DTAARA *EXCLRD))                 /*S01271*/
                                                                      /*S01271*/
 
             SNDPGMMSG  MSG('Input Cycle Confirmation Reprint') +
                          TOMSGQ(MRUNQ)
/**/
             CHGJOB     SWS(00000000)
/**/
/*********** OVRDBF     FILE(TRDCONF) TOFILE(TRDCFR)                    S01117*/
/**/
/*********** CALL       PGM(SE0551)                                     S01117*/
             CALL       PGM(SE0551) PARM(&RSEQ &RENT &RCMD)           /*S01117*/
             IF         COND((&RCMD = 'E') *OR (&RCMD = 'F')) +
                          THEN(GOTO CMDLBL(ERROR))                    /*S01117*/
/**/
 
/* */                                                                 /*S01117*/
/** SE0551 no longer calls SE0550. RCF calls SE0550 through the    */ /*S01117*/
/** new cl SEC0309 and this will reset the flag to 'N'.            */ /*S01117*/
/* */                                                                 /*S01117*/
/***ALLOCATE*SESTAT,*INDICATE*CONFIRMATION*PRINT*IS*FINISHED**/ /*S01271S01117*/
/***AND*THEN*DEALLOCATE.*                                    */ /*S01271S01117*/
/***********                                                      S01271S01117*/
/*********** ALCOBJ     OBJ((SESTAT *DTAARA *EXCLRD))             S01271S01117*/
/*********** RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)            S01271S01117*/
/*********** CHGVAR     VAR(%SUBSTRING(&SESTAT 73 1)) VALUE('N')  S01271S01117*/
/*********** CHGDTAARA  DTAARA(SESTAT) VALUE(&SESTAT)             S01271S01117*/
/*********** DLCOBJ     OBJ((SESTAT *DTAARA *EXCLRD))             S01271S01117*/
             ENDDO                                                    /*S01271*/
             ENDDO                                                    /*S01271*/
                                                                      /*S01271*/
             GOTO ENDPGM                                              /*S01117*/
 
/* */                                                                 /*S01117*/
ERROR:                                                                /*S01117*/
/* */                                                                 /*S01117*/
/** Error processing                                               */ /*S01117*/
/* */                                                                 /*S01117*/
/*  ABNORMAL TERMINATION MESSAGE - DATABASE ERROR                   */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
/*           CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44))         /* /*S01117*/
             CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))            /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             SNDPGMMSG  MSG('(SE0551) - Database Error') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
/*********** GOTO ENDPGM                                              /*S01117*/
             ENDDO
/* */                                                                 /*S01117*/
/** Allocate SESTAT, indicate confirmation print is finished       */ /*S01117*/
/** and then deallocate.                                           */ /*S01117*/
/* */                                                                 /*S01117*/
                                                                      /*S01117*/
             ALCOBJ     OBJ((SESTAT *DTAARA *EXCLRD))                 /*S01117*/
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)                /*S01117*/
             CHGVAR     VAR(%SUBSTRING(&SESTAT 73 1)) VALUE('N')      /*S01117*/
             CHGDTAARA  DTAARA(SESTAT) VALUE(&SESTAT)                 /*S01117*/
             DLCOBJ     OBJ((SESTAT *DTAARA *EXCLRD))                 /*S01117*/
/* */                                                                 /*S01117*/
/** Set return code for RCF                                        */ /*S01117*/
/* */                                                                 /*S01117*/
             IF         COND(&RCMD *NE 'F') THEN(CHGVAR VAR(&RCMD) +
                          VALUE('E'))                                 /*S01117*/
                                                                      /*S01117*/
/* */                                                                 /*S01117*/
             GOTO ENDPGM                                              /*S01117*/
/**/
/*ENDPGM:****ENDPGM*******                                             *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01117*/
