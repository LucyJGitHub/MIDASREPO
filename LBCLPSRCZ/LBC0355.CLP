/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Borrowing Power Weighting Selection. I/C')      */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Lending Module                        */
/*                                                                   */
/*       LBC0355 - Borrowing Power Weighting Report   (I/C)          */
/*                 (Calls LB0355)                                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01498             DATE 11AUG94              */
/*       PREV AMEND NO. R00300             DATE 28AUG90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       S01498 - Portfolio Lending Upgrade to Release 10            */
/*                (Previously called LBC0356)                        */
/*       R00300 - Message file changes                               */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                      /*S01498*/
             PGM        PARM(&RSEQ &RLVL &RENT &RPARM)                /*S01498*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01498*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1) /* RCF level +
                          flag (S/C/B)                                /*S01498*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity +
                          code (all/comp/bch)                         /*S01498*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*S01498*/
 
/*********** DCL        VAR(&IDCODE) TYPE(*CHAR) LEN(2) VALUE('LB')*/ /*S01498*/
/***********      DEFINES FILE MEMBER AS PORTFOLIO LENDING         */ /*S01498*/
/*********** DCL        VAR(&JOBNO) TYPE(*CHAR) LEN(6)             */ /*S01498*/
/***********      CURRENT UNIQUE JOB NUMBER                        */ /*S01498*/
/*********** DCL        VAR(&MBRNAM) TYPE(*CHAR) LEN(10)           */ /*S01498*/
/***********      UNIQUE STRDBJWK FILE MEMBER NAME                 */ /*S01498*/
/*********** DCL        VAR(&RETCOD) TYPE(*CHAR) LEN(1) VALUE(' ') */ /*S01498*/
/***********      LB0356 RETURN CODE                               */ /*S01498*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(52)
/**               FOR DATABASE ERROR MESSAGES                        */
/**/
/**   GLOBAL ERROR TRAP                                              */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNORMAL))
/**   RESET JOB SWITCHES                                             */
             CHGJOB     SWS(XXXXXX00)
/**/
/*********** RTVJOBA    NBR(&JOBNO)                                */ /*S01498*/
/**/
/*********** CHGVAR     VAR(&MBRNAM) VALUE(&IDCODE *CAT &JOBNO)    */ /*S01498*/
/*********** ADDPFM     FILE(STRDBJWK) MBR(&MBRNAM)                */ /*S01498*/
/*********** OVRDBF     FILE(STRDBJWK) MBR(&MBRNAM)                */ /*S01498*/
/**/
/**/
/*********** CALL       PGM(LB0356) PARM(&RETCOD)                  */ /*S01498*/
             CALL       PGM(LB0355) PARM(&RSEQ &RPARM)                /*S01498*/
/**/
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
                SNDPGMMSG  MSG('Transaction failed. Re-input necessary. +
                          Press ENTER to continue.') TOPGMQ(*EXT)
                GOTO       CMDLBL(THEEND)
                ENDDO
/**/
/**IF U7 AND U8 ARE ON SEND DATA BASE ERROR MESSAGE TO MOPERQ & *EXT */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MSG)
                                                                      /*R00300*/
/************SNDPGMMSG  MSGID(DBM0001) MSGF(LXGBMSGF) MSGDTA(&MSG) +
**************************TOMSGQ(MOPERQ)                             */
/*********** SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRMSG) MSGDTA(&MSG) +  /*S01498*/
/***********              TOMSGQ(MOPERQ)                           */ /*S01498*/
                SNDPGMMSG  MSGID(DBM0001) MSGF(LBUSRMSG)  +
                             MSGDTA(&MSG) TOMSGQ(MOPERQ)              /*S01498*/
                                                                      /*R00300*/
/***********    SNDPGMMSG  MSG('LBC0356 - JOB TERMINATED - DATABASE IN +
/***********              ERROR') TOPGMQ(*EXT)                     */ /*S01498*/
                SNDPGMMSG  MSG('LBC0355 - JOB TERMINATED - +
                              DATABASE IN ERROR') TOPGMQ(*EXT)        /*S01498*/
                GOTO       CMDLBL(THEEND)
                ENDDO
/**/
/**IF*SELECTION*PROGRAM*SUCCESSFULLY*PROCESSED*A*VALID*SELECTION****/ /*S01498*/
/**THEN*SUBMIT*DATABASE*JOB*TO*RUN*REPORT***************************/ /*S01498*/
/*********** IF         COND(&RETCOD *EQ '1') THEN(DO)             */ /*S01498*/
/***********    SBMDBJOB   FILE(STRDBJWK) MBR(&MBRNAM)             */ /*S01498*/
/***********    CHGVAR     VAR(&RETCOD) VALUE(' ')                 */ /*S01498*/
/***********    ENDDO                                              */ /*S01498*/
/**/
             GOTO       CMDLBL(THEEND)
/**/
 ABNORMAL:   DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
/*********** SNDMSG     MSG('LBC0356 ended abnormally') TOUSR(*SYSOPR)/*S01498*/
             SNDMSG     MSG('LBC0355 ended abnormally') +
                           TOUSR(*SYSOPR)                             /*S01498*/
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
 THEEND:     RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
/*********** DLTOVR     FILE(STRDBJWK)                             */ /*S01498*/
/*********** MONMSG     MSGID(CPF0000 MCH0000)                     */ /*S01498*/
/*********** RMVM       FILE(STRDBJWK) MBR(&MBRNAM)                */ /*S01498*/
/*********** MONMSG     MSGID(CPF0000 MCH0000)                     */ /*S01498*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
