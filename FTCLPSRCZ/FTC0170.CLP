/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT Cheques To Be Collected Selection')          */
/*********************************************************************/
/*                                                                   */
/*       Midas       FUNDS TRANSFER MODULE                       */
/*                       PAYMENTS MODULE                             */
/*                                                                   */
/*       FTC0170    CHEQUES TO BE COLLECTED SELECTION                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO.  048377           DATE     22DEC92           */
/*       PREV AMEND NO.  S01194           DATE     19SEP90           */
/*                       XXXXXX           DATE     DDMMMYY           */
/*                                                                   */
/*********************************************************************/
/*  048377 - RECORD LOCKING PROBLEM IN FT PGMS                       */
/*           (REFER TO ERROR 042167 & 044093)                        */
/*********************************************************************/
             PGM
 
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                 /*S01194*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01194*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
                                                                      /*048377*/
             DCL        VAR(&MODULE) TYPE(*CHAR) LEN(2)               /*048377*/
             DCL        VAR(&TRNREF) TYPE(*CHAR) LEN(15)              /*048377*/
             DCL        VAR(&RINFOR) TYPE(*CHAR) LEN(80)              /*048377*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)               /*048377*/
 
             CHGJOB     SWS(XXXXXX00)
 
/*  CALL PROGRAM & MONITOR FOR ERRORS                               */
 
             CALL       PGM(FT0170)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
             SNDPGMMSG  MSG('Transaction Failed. Re-input necessary. +
                          Press Enter to Continue.') TOPGMQ(*EXT)
             GOTO       CMDLBL(END)
             ENDDO
 
/**   DATABASE ERROR HANDLING   **/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)             /*S01194*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01194*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
 
/*END:*******ENDPGM                                                   /*S01194*/
END:                                                                  /*S01194*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/                                                                  /*048377*/
/* CALL AOC8000 to release locks */                                   /*048377*/
/**/                                                                  /*048377*/
             CHGVAR     VAR(&MODULE) VALUE('FT')                      /*048377*/
             CHGVAR     VAR(&TRNREF) VALUE('               ')         /*048377*/
             CHGVAR     VAR(&RINFOR) VALUE('    ')                    /*048377*/
             CHGVAR     VAR(&RTNCDE) VALUE('       ')                 /*048377*/
             CALL       PGM(AOC8000) PARM(&RTNCDE &MODULE &TRNREF +
                          &RINFOR)                                    /*048377*/
/**/                                                                  /*048377*/
             ENDPGM
 
