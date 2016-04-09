/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Portfolio Lending Analysis')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Lending Module                        */
/*                                                                   */
/*       LBC0310 - Portfolio Lending Analysis                        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 092963             DATE 18SEP95              */
/*       PREV AMEND NO. S01498             DATE 11AUG94              */
/*                      R0738              DATE 16JAN91              */
/*                      R00300             DATE 28AUG90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       092963 - Clear *LDA after enquiry                           */
/*       S01498 - Portfolio Lending Upgrade to Release 10            */
/*       R0738  - Parents are not declared as Portfolio lending      */
/*                clients                                            */
/*       R00300 - Message file changes                               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/                                                                  /*S01498*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&PRM1) TYPE(*CHAR) LEN(1) VALUE('0')
/**               PARAMETER 1 FOR LB0310 - CALLED FROM MENU          */
             DCL        VAR(&PRM2) TYPE(*DEC) LEN(6 0) VALUE(0)
/**               PARAMETER 2 FOR LB0310 - CUSTOMER NUMBER           */
             DCL        VAR(&PRM3) TYPE(*CHAR) LEN(1) VALUE('0')
/**               PARAMETER 3 FOR LB0310 - RETURNED FN KEY VALUE     */
             DCL        VAR(&PRM4) TYPE(*CHAR) LEN(10)
/**               PARAMETER 4 FOR LB0310 - USER PROFILE DESCRIPTION  */
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(52)
/**               FOR DATABASE ERROR MESSAGES                        */
/**/
/**   GLOBAL ERROR TRAP                                              */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNORMAL))
/**   RESET JOB SWITCHES                                             */
             CHGJOB     SWS(XXXXXX00)
/**/
             RTVUSRPRF  RTNUSRPRF(&PRM4)
/**/
/*********** OVRDBF     FILE(SDLBCSL0) TOFILE(SDLBCSLG)      */ /*R0738 S01498*/
             OVRDBF     FILE(LBLBCSJ0) TOFILE(LBLBCSJG)               /*S01498*/
             CALL       PGM(LB0310) PARM(&PRM1 &PRM2 &PRM3 &PRM4)
                                                                      /*092963*/
             CHGDTAARA  DTAARA(*LDA) VALUE(' ')                       /*092963*/
                                                                      /*092963*/
/*********** DLTOVR     FILE(SDLBCSL0)                       */ /*R0738 S01498*/
             DLTOVR     FILE(LBLBCSJ0)                                /*S01498*/
/**/
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
                SNDPGMMSG  MSG('Transaction failed. Re-input necessary. +
                           Press ENTER to continue.') TOPGMQ(*EXT)
                GOTO       CMDLBL(ENDPGM)
                ENDDO
/**/
/**  IF U7 & U8 ARE ON SEND DATABASE ERROR MESSAGE TO MOPERQ & *EXT  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MSG)
                                                                      /*R00300*/
/***************SNDPGMMSG  MSGID(DBM0001) MSGF(LXGBMSGF) MSGDTA(&MSG) +
***************************TOMSGQ(MOPERQ)                            */
/*********** SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRMSG) MSGDTA(&MSG)+*/ /*S01498*/
/***********            TOMSGQ(MOPERQ)                             */ /*S01498*/
                                                                      /*R00300*/
             SNDPGMMSG  MSGID(DBM0001) MSGF(LBUSRMSG) MSGDTA(&MSG) +
                          TOMSGQ(MOPERQ)                              /*S01498*/
                SNDPGMMSG  MSG('LBC0310 - JOB TERMINATED - DATABASE IN +
                           ERROR') TOPGMQ(*EXT)
                ENDDO
/**/
             GOTO       CMDLBL(ENDPGM)
 ABNORMAL:   DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDMSG     MSG('LBC0310 ended abnormally') TOUSR(*SYSOPR)
             MONMSG     MSGID(CPF0000 MCH0000)
/*ENDPGM:***  ENDPGM                                               */ /*S01498*/
 ENDPGM:                                                              /*S01498*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01498*/
