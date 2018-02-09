/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Porfolio Lending Group/Instrument Report')      */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Lending Module                        */
/*                                                                   */
/*       LBC0385 - Portfolio Lending Groups/Instruments Report (I/C) */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01498             Date 11Aug94              */
/*                      R00300             Date 28Aug90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01498 - Portfolio Lending Upgrade to Release 10            */
/*       R00300 - Message file changes                               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                   */
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)                /*S01498*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&IDCODE) TYPE(*CHAR) LEN(2) VALUE('LB')
/**               DEFINES FILE MEMBER AS PORTFOLIO LENDING             */
             DCL        VAR(&JOBNO) TYPE(*CHAR) LEN(6)
/**               CURRENT UNIQUE JOB NUMBER                          */
             DCL        VAR(&MBRNAM) TYPE(*CHAR) LEN(10)
/**               UNIQUE STRDBJWK FILE MEMBER NAME                   */
             DCL        VAR(&RETCOD) TYPE(*CHAR) LEN(1) VALUE(' ')
/**               LB0386 RETURN CODE                                 */
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(52)
/**               FOR DATABASE ERROR MESSAGES                        */
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01498*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01498*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01498*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*S01498*/
             DCL        VAR(&WWPLGR) TYPE(*CHAR) LEN(4)               /*S01498*/
/**/
/**   GLOBAL ERROR TRAP                                              */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNORMAL))
/**/
/*********** RTVJOBA    NBR(&JOBNO)                                */ /*S01498*/
/**/
/*********** CHGVAR     VAR(&MBRNAM) VALUE(&IDCODE *CAT &JOBNO)    */ /*S01498*/
/*********** ADDPFM     FILE(STRDBJWK) MBR(&MBRNAM)                */ /*S01498*/
/*********** OVRDBF     FILE(STRDBJWK) MBR(&MBRNAM)                */ /*S01498*/
/**/
/**   RESET JOB SWITCHES                                             */
             CHGJOB     SWS(XXXXXX00)
/**/                                                                  /*S01498*/
             CHGVAR     VAR(&WWPLGR) VALUE(%SUBSTRING(&RPARM 1 4))    /*S01498*/
/**/
/*********** CALL       PGM(LB0386) PARM(&RETCOD)                  */ /*S01498*/
             CALL       PGM(LB0385) PARM('1' &WWPLGR &RSEQ)           /*S01498*/
/**/
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
             SNDPGMMSG  MSG('Transaction failed. Re-input necessary. +
                            Press ENTER to continue.') TOPGMQ(*EXT)
                GOTO       CMDLBL(THEEND)
                ENDDO
/**/
/**IF U7 AND U8 ARE ON SEND DATA BASE ERROR MESSAGE TO MOPERQ & *EXT */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
      RTVDTAARA DTAARA(LDA (132 52)) RTNVAR(&MSG)
                                                                      /*R00300*/
/*****SNDPGMMSG MSGID(DBM0001) MSGF(LXGBMSGF) MSGDTA(&MSG) +
******************TOMSGQ(MOPERQ)                                     */
/*****SNDPGMMSG MSGID(DBM0001) MSGF(CEUSRMSG) MSGDTA(&MSG) +       */ /*S01498*/
/***********      TOMSGQ(MOPERQ)                                   */ /*S01498*/
             SNDPGMMSG  MSGID(DBM0001) MSGF(LBUSRMSG) MSGDTA(&MSG) +
                          TOMSGQ(MOPERQ)                              /*S01498*/
                                                                      /*R00300*/
/*********** SNDPGMMSG MSG('LBC0386 - JOB TERMINATED - DATABASE IN+*/ /*S01498*/
/***********                ERROR') TOPGMQ(*EXT)                   */ /*S01498*/
             SNDPGMMSG  MSG('LBC0385 - JOB TERMINATED - DATABASE IN +
                            ERROR') TOPGMQ(*EXT)                      /*S01498*/
                GOTO       CMDLBL(THEEND)
                ENDDO
/**/
/*********** IF         COND(&RETCOD *EQ '1') THEN(DO)             */ /*S01498*/
/***********    SBMDBJOB   FILE(STRDBJWK) MBR(&MBRNAM)             */ /*S01498*/
/***********    CHGVAR     VAR(&RETCOD) VALUE(' ')                 */ /*S01498*/
/***********    ENDDO                                              */ /*S01498*/
/**/
             GOTO       CMDLBL(THEEND)
/**/
 ABNORMAL:   DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
/*********** SNDMSG  MSG('LBC0386 ended abnormally') TOUSR(*SYSOPR)*/ /*S01498*/
             SNDMSG     MSG('LBC0385 ended abnormally') TOUSR(*SYSOPR)
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
                          Finastra International Limited')
             ENDPGM
