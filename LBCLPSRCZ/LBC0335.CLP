/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Portfolio Lending Groups/Instruments Enq')      */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Lending Module                        */
/*                                                                   */
/*       LBC0335 - Portfolio Lending Instrument/Group Enquiry        */
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
DCL VAR(&MSG) TYPE(*CHAR) LEN(52)      /* FOR DATABASE ERROR MESSAGES*/
MONMSG MSGID(CPF0000 MCH0000 RPG0000) +
       EXEC(GOTO CMDLBL(ABNORMAL))     /* GLOBAL ERROR TRAP          */
CHGJOB SWS(XXXXXX00)                   /* RESET JOB SWITCHES         */
CALL PGM(LB0335)
MONMSG MSGID(RPG0000 CPF0000 MCH0000) +
       EXEC(DO)
       SNDPGMMSG MSG('Transaction failed. Re-input necessary. +
                      Press ENTER to continue.') TOPGMQ(*EXT)
       GOTO CMDLBL(ENDPGM)
       ENDDO
                                       /* IF U7 & U8 ARE ON SEND DATA*/
                                       /* BASE ERROR MESSAGE TO      */
                                       /* MOPERQ                     */
IF COND(%SWITCH(XXXXXX11)) THEN(DO)
RTVDTAARA DTAARA(LDA (132 52)) RTNVAR(&MSG)
                                                                      /*R00300*/
/*SNDPGMMSG MSGID(DBM0001) MSGF(LXGBMSGF) MSGDTA(&MSG) TOMSGQ(MOPERQ)*/
/*SNDPGMMSG MSGID(DBM0001) MSGF(CEUSRMSG) MSGDTA(&MSG) TOMSGQ(MOPERQ) /*S01498*/
                                                                      /*R00300*/
             SNDPGMMSG  MSGID(DBM0001) MSGF(LBUSRMSG) MSGDTA(&MSG) +
                          TOMSGQ(MOPERQ)                              /*S01498*/
SNDPGMMSG  MSG('Transaction failed. Re-input necessary. +
                Press ENTER to continue.') TOPGMQ(*EXT)
GOTO CMDLBL(ENDPGM)
ENDDO
GOTO CMDLBL(ENDPGM)
ABNORMAL: DMPCLPGM
          MONMSG MSGID(CPF0000 MCH0000)
          SNDMSG MSG('LBC0335 ended abnormally') TOUSR(*SYSOPR)
          MONMSG MSGID(CPF0000 MCH0000)
/*ENDPGM:***ENDPGM                                                 */ /*S01498*/
 ENDPGM:                                                              /*S01498*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01498*/
