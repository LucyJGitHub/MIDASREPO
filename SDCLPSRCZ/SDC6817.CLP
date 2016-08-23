/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UDC - format name combinations rpt')            */
/********************************************************************** S37004*/
/*                                                                   */
/*       Midas     - Standing Data Module                        */
/*                                                                   */
/*       SDC6817 -  U.D.C.  FORMAT NAME COMBINATIONS.                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 053522             DATE 10JAN94              */
/*       PREV AMEND NO. AUS009             DATE 22JUN92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       053522 - Pgm should send msg to MRUNQ/MOPERQ, Not to *EXT.  */
/*                Also, Database error should be handled.            */
/*       AUS009 - AUSTRALIAN PRODUCT - USER DEFINED CONFIRMATIONS    */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&RSEQ &RLVL &RENT)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01390*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*S01390*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01390*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)               /*053522*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)               /*053522*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                             EXEC(GOTO CMDLBL(ABNOR))                /*053522*/
/**/
             CALL       PGM(SD6817) PARM(&RSEQ)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)             /*053522*/
                  RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                /*053522*/
                  CHGVAR     VAR(&MEM) VALUE( +
                                  %SUBSTRING(&LDA 134 50))           /*053522*/
                  SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                                  MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ)  /*053522*/
                  CHGVAR     VAR(&MEM) VALUE('SDC6817 - Job +
                                  Terminated, Database in Error')    /*053522*/
                  SNDPGMMSG  MSG(&MEM) TOMSGQ(MOPERQ)                /*053522*/
             ENDDO                                                   /*053522*/
                  GOTO ENDPGM                                        /*053522*/
/************     MONMSG     MSGID(CPF0000 RPG0000 MCH0000)    +  */ /*053522*/
/************         EXEC( SNDPGMMSG MSG('Transaction failed. +  */ /*053522*/
/************         re-input necessary. Enter to continue.') +  */ /*053522*/
/************         TOPGMQ(*EXT))                               */ /*053522*/
/**/
ABNOR:       SNDPGMMSG  MSG('Job terminated abnormally.        +
                             See joblog for further details.') +
                             TOMSGQ(MRUNQ MOPERQ)                    /*053522*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)               /*053522*/
ENDPGM:                                                              /*053522*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
