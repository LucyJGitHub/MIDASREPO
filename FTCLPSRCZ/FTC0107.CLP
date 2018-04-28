/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT Multiple Authorisation Pgm Driver')          */
/*********************************************************************/
/*                                                                   */
/*       Midas     PAYMENTS MODULE                                   */
/*                                                                   */
/*       FTC0107    MULTIPLE AUTHORISATION                           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMENDMENT NO. 042167             DATE  21JUL92         */
/*                          000000             DATE  00MMMYY         */
/*********************************************************************/
/*       042167  -  Include CL Program for record locking            */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PARA)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&PARA) TYPE(*CHAR) LEN(1)
/**/
             DCL   VAR(&MEM)   TYPE(*CHAR)   LEN(50)
/**/
                                                                      /*042167*/
             DCL        VAR(&MODULE) TYPE(*CHAR) LEN(2)               /*042167*/
             DCL        VAR(&TRNREF) TYPE(*CHAR) LEN(15)              /*042167*/
             DCL        VAR(&RINFOR) TYPE(*CHAR) LEN(80)              /*042167*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)               /*042167*/
/**/
             CHGJOB SWS(XXXXXX00)
/**/
/** Call program & monitor for untrapped errors **/
/**/
             CALL       PGM(FT0107) PARM(&PARA)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
                        SNDPGMMSG  MSG('Transaction Failed. +
                                        Re-input necessary. +
                                        Press Enter to Continue.') +
                                   TOPGMQ(*EXT)
                        GOTO FINISH
             ENDDO
/**/
/**   Database error handling   **/
/**/
             IF   COND(%SWITCH(XXXXXX11))   THEN(DO)
                RTVDTAARA   DTAARA(LDA (134 50))   RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                    TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/************FINISH: ENDPGM*****************************************/ /*042167*/
 FINISH:                                                              /*042167*/
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
            ENDPGM                                                    /*042167*/
/**/
