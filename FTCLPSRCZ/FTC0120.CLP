/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT Cheques For Collection Authoris'n')          */
/*********************************************************************/
/*                                                                   */
/*       Midas       FUNDS TRANSFER MODULE                       */
/*                                                                   */
/*       FTC0120    CHEQUES FOR COLLECTION AUTHORISATION             */
/*                            SELECTION                              */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMENDMENT NO. 048377             DATE  22DEC92         */
/*       LAST AMENDMENT NO. S01117             DATE  21SEP90         */
/*       PREV AMENDMENT NO. S01194             DATE  21SEP90         */
/*                                                                   */
/*********************************************************************/
/*       048377  -  RECORD LOCKING PROBLEM IN FT PGMS                */
/*                 (REFER TO ERROR 042167 & 044093)                  */
/*       S01194  -  NEW DATABASE HANDLING                            */
/*       S01117  -  RELEASE 10 MULTIBRANCHING CHANGES                */
/*********************************************************************/
/**          PGM                                                      /*S01117*/
             PGM        PARM(&BRCH &BORO &PCMD)                       /*S01117*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**          DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                 /*S01194*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01194*/
             DCL        VAR(&BRCH) TYPE(*CHAR) LEN(3)                 /*S01117*/
             DCL        VAR(&BORO) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(1)                 /*S01117*/
                                                                      /*048377*/
             DCL        VAR(&MODULE) TYPE(*CHAR) LEN(2)               /*048377*/
             DCL        VAR(&TRNREF) TYPE(*CHAR) LEN(15)              /*048377*/
             DCL        VAR(&RINFOR) TYPE(*CHAR) LEN(80)              /*048377*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)               /*048377*/
 
             CHGJOB     SWS(XXXXXX00)
 
/*  CALL PROGRAM & MONITOR FOR ERRORS                               */
 
/**          CALL       PGM(FT0120)                                   /*S01117*/
             CALL       PGM(FT0120) PARM(&BRCH &BORO &PCMD)           /*S01117*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
             SNDPGMMSG  MSG('Transaction Failed. Re-input necessary. +
                          Press Enter to Continue.') TOPGMQ(*EXT)
             GOTO       CMDLBL(END)
             ENDDO
 
/**   DATABASE ERROR HANDLING   **/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
 /**         RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)             /*S01194*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01194*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
 
/**END:********ENDPGM                                                 /*S01117*/
/**/                                                                  /*S01117*/
 END:                                                                 /*S01117*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/                                                                  /*048377*/
/* CALL AOC8000 to release locks */                                   /*048377*/
/* */                                                                 /*048377*/
             CHGVAR     VAR(&MODULE) VALUE('FT')                      /*048377*/
             CHGVAR     VAR(&TRNREF) VALUE('               ')         /*048377*/
             CHGVAR     VAR(&RINFOR) VALUE('    ')                    /*048377*/
             CHGVAR     VAR(&RTNCDE) VALUE('       ')                 /*048377*/
             CALL       PGM(AOC8000) PARM(&RTNCDE &MODULE &TRNREF +
                          &RINFOR)                                    /*048377*/
/**/                                                                  /*S01117*/
            ENDPGM                                                    /*S01117*/
 
