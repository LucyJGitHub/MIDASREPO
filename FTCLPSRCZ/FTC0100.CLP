/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT Nostro Transfers Maintenance')               */
/********************************************************************/
/*                                                                  */
/*       Midas       FUNDS TRANSFER MODULE  STANDING DATA       */
/*                                                                  */
/*       FTC0100  - CL COMPONENT TO CONTROL FT0100                  */
/*                  NOSTRO TRANSFER MAINTENANCE.                    */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO.  042167           DATE     15APR93          */
/*       PREV AMEND NO.  S01194           DATE     21AUG90          */
/*                                                                  */
/*                                                                  */
/********************************************************************/
/*       042167 - CL PROGRAM FOR RECORD LOCKING                     */
/*       S01194 - NEW DATABASE HANDLING REL10                       * /*S01194*/
/******************************************************************** /*S01194*/
             PGM        PARM(&SORT &PREF &RTCD)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/************DCL        VAR(&DATA) TYPE(*CHAR) LEN(44)                /*S01194*/
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)                /*S01194*/
             DCL        VAR(&SORT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(15) /* Payment +
                          reference. */
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(1)
                                                                      /*042167*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)               /*042167*/
             DCL        VAR(&MODULE) TYPE(*CHAR) LEN(2)               /*042167*/
             DCL        VAR(&TRNREF) TYPE(*CHAR) LEN(15)              /*042167*/
             DCL        VAR(&RINFOR) TYPE(*CHAR) LEN(80)              /*042167*/
 
       CHGJOB     SWS(XXXXXX00)
 
/** Call program & monitor for untrapped errors **/
 
             CALL       PGM(FT0100) PARM(&SORT &PREF &RTCD)
       MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
                  ROLLBACK
                  SNDPGMMSG  MSG('Transaction Failed. +
                                  Re-input necessary. +
                                  Press Enter to Continue.') +
                             TOPGMQ(*EXT)
                  GOTO END
       ENDDO
 
/** Check for database errors trapped by program **/
 
       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                  ROLLBACK
/***************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&DATA)         /*S01194*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*S01194*/
                  SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
       ENDDO
 
/*END:*******ENDPGM                                                   /*S01194*/
END:                                                                  /*S01194*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
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
             ENDPGM
