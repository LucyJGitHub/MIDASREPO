/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Commitment Lines Expiring/Review Rep I/C')      */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Lending Module                        */
/*                                                                   */
/*       LBC0376 - Commitment Lines Expiring/Review Report (I/C)     */
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
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       S01498 - Portfolio Lending Upgrade to Release 10            */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                   */ /*S01498*/
             PGM        PARM(&RSEQ &RLVL &RENT &RPARM)                /*S01498*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01498*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*S01498*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01498*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*S01498*/
 
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(52)
/**               FOR DATABASE ERROR MESSAGES                        */
 
/**   GLOBAL ERROR TRAP                                              */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNORMAL))
 
/**   RESET JOB SWITCHES                                             */
             CHGJOB     SWS(XXXXXX00)
 
/*********** CALL       PGM(LB0376)                                */
             CALL       PGM(LB0375) PARM('1' &RSEQ &RLVL &RENT +
                           &RPARM)                                    /*S01498*/
 
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
/*********** SNDPGMMSG  MSG('Transaction failed. Re-input necessary. +
                          Press ENTER to continue.') TOPGMQ(*EXT)  */ /*S01498*/
/*********** GOTO       CMDLBL(THEEND)                             */ /*S01498*/
             CHGJOB  SWS(XXXXXX11)                                    /*S01498*/
             GOTO       CMDLBL(ABNORMAL)                              /*S01498*/
             ENDDO
 
/**IF U7 AND U8 ARE ON SEND DATA BASE ERROR MESSAGE TO MOPERQ & *EXT */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MSG)
/*********** SNDPGMMSG  MSGID(DBM0001) MSGF(LXGBMSGF) MSGDTA(&MSG) +
                          TOMSGQ(MOPERQ)                           */ /*S01498*/
/*********** SNDPGMMSG  MSG('LBC0376 - JOB TERMINATED - DATABASE IN +
                          ERROR') TOPGMQ(*EXT)                     */ /*S01498*/
/*********** GOTO       CMDLBL(THEEND)                             */ /*S01498*/
/**/                                                                  /*S01498*/
             SNDPGMMSG  MSGID(DBM0001) MSGF(LBUSRMSG) +
                          MSGDTA(&MSG) TOMSGQ(MOPERQ MRUNQ)           /*S01498*/
             GOTO       CMDLBL(ABNORMAL)                              /*S01498*/
             ENDDO
/**/                                                                  /*S01498*/
/** Check for file control errors trapped by the program */           /*S01498*/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)              /*S01498*/
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MSG)          /*S01498*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(LBUSRMSG) +
                             MSGDTA(&MSG) TOMSGQ(MOPERQ MRUNQ)        /*S01498*/
                GOTO       CMDLBL(ABNORMAL)                           /*S01498*/
             ENDDO                                                    /*S01498*/
 
             GOTO       CMDLBL(THEEND)
 
 ABNORMAL:   DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDMSG     MSG('LBC0376 ended abnormally') TOUSR(*SYSOPR)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 THEEND:     RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
