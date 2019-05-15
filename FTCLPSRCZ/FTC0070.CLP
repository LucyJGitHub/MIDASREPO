/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas FT Cheques For Collection Maint.')              */
/********************************************************************/
/*                                                                  */
/*       Midas     FUNDS TRANSFER                                   */
/*                                                                  */
/*       FTC0070  - CL COMPONENT TO CONTROL FT0070                  */
/*                  CHEQUES TO BE COLLECTED MAINTENANCE.            */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CER049             Date 06Dec10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      048377             Date 22Dec92              */
/*                      S01117            DATE  13MAY91             */
/*                      S01194            DATE  18OCT90             */
/*                                                                  */
/********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*       CER049 - Stamp Tax                                         */
/*       048377  -  RECORD LOCKING PROBLEM IN FT PGMS               */
/*                  (REFER TO ERROR 042167 & 044093)                */
/*       S01117  -  MULTIBRANCHING CHANGES                          */
/*       S01194  -  DATABASE FIELD LENGTH CHANGES                   */
/********************************************************************/
             PGM        PARM(&SORT &PREF &RTCD)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/******DCL        VAR(&DATA) TYPE(*CHAR) LEN(44)                     /*S01194*/
       DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)                     /*S01194*/
             DCL        VAR(&SORT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(15) /* Payment +
                          reference. */
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)               /*048377*/
             DCL        VAR(&MODULE) TYPE(*CHAR) LEN(2)               /*048377*/
             DCL        VAR(&TRNREF) TYPE(*CHAR) LEN(15)              /*048377*/
             DCL        VAR(&RINFOR) TYPE(*CHAR) LEN(80)              /*048377*/
 
       CHGJOB     SWS(XXXXXX00)
 
/** Call program & monitor for untrapped errors **/
 
/*/COPY WNCPYSRC,FTC0070001                                          */
                                                                                          /*CER049*/
/** Override Stamp Tax Control File as this file will be updated   */                     /*CER049*/
/** twice by the same job.                                         */                     /*CER049*/
                                                                                          /*CER049*/
             OVRDBF     FILE(CQCOCDQD) SHARE(*NO)                                         /*CER049*/
             OVRDBF     FILE(CQCOCQL0) SHARE(*NO)                                         /*CER049*/
                                                                                          /*CER049*/
             CALL       PGM(FT0070) PARM(&SORT &PREF &RTCD)
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
/*****************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&DATA)      /*S01194*/
                  RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)      /*S01194*/
                  SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
       ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/* */                                                                 /*048377*/
/* CALL AOC8000 to release locks */                                   /*048377*/
/* */                                                                 /*048377*/
             CHGVAR     VAR(&MODULE) VALUE('FT')                      /*048377*/
             CHGVAR     VAR(&TRNREF) VALUE('               ')         /*048377*/
             CHGVAR     VAR(&RINFOR) VALUE('    ')                    /*048377*/
             CHGVAR     VAR(&RTNCDE) VALUE('       ')                 /*048377*/
             CALL       PGM(AOC8000) PARM(&RTNCDE &MODULE &TRNREF +
                          &RINFOR)                                    /*048377*/
/* */                                                                 /*048377*/
             ENDPGM                                                  /*S01117*/
/* END:         ENDPGM                                               /*S01117*/
