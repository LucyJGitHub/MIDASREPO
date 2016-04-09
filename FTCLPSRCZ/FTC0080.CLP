/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas FT Cheques To Be Paid Maint. Level 1')          */
/********************************************************************/
/*                                                                  */
/*       Midas     FUNDS TRANSFER                                   */
/*                                                                  */
/*       FTC0080  - CL COMPONENT TO CONTROL FT0080                  */
/*                  CHEQUES TO BE PAID MAINTENANCE.                 */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. CER049             Date 06Dec10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. E42167(PSS206)    DATE  29JUL92             */
/*                      S01117            DATE  16OCT90             */
/*                      S01194            DATE  16OCT90             */
/*                                                                  */
/********************************************************************/
/*       CER049 - Stamp Tax                                         */
/*       E42167 - CL PROGRAM FOR RECORD LOCKING                     */
/*       S01117 - MULTIBRANCHING INCORPORATION                      */
/*       S01194 - NEW DATABASE ERROR HANDLING                       */
/********************************************************************/
             PGM        PARM(&SORT &PREF &RTCD &LINK)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/*           DCL        VAR(&DATA) TYPE(*CHAR) LEN(44)       */      /*S01194*/
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)               /*S01194*/
             DCL        VAR(&SORT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(15) /* Payment +
                          reference. */
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LINK) TYPE(*CHAR) LEN(1)
                                                                      /*042167*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)               /*042167*/
             DCL        VAR(&MODULE) TYPE(*CHAR) LEN(2)               /*042167*/
             DCL        VAR(&TRNREF) TYPE(*CHAR) LEN(15)              /*042167*/
             DCL        VAR(&RINFOR) TYPE(*CHAR) LEN(80)              /*042167*/
 
   CHGJOB     SWS(XXXXXX00)
 
/*  CALL PROGRAM & MONITOR FOR ERRORS                               */
 
/*/COPY WNCPYSRC,FTC0080001                                          */
                                                                                          /*CER049*/
/** Override Stamp Tax Control File as this file will be updated   */                     /*CER049*/
/** twice by the same job.                                         */                     /*CER049*/
                                                                                          /*CER049*/
             OVRDBF     FILE(CQPQCDQD) SHARE(*NO)                                         /*CER049*/
             OVRDBF     FILE(CQPACQL0) SHARE(*NO)                                         /*CER049*/
                                                                                          /*CER049*/
             CALL       PGM(FT0080) PARM(&SORT &PREF &RTCD &LINK)
   MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
              ROLLBACK
              SNDPGMMSG  MSG('Transaction Failed. Re-input necessary. +
                              Press Enter to Continue.') TOPGMQ(*EXT)
              GOTO END
   ENDDO
 
   IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
              ROLLBACK
/*            RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&DATA)    */    /*S01194*/
              RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
              SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                         TOPGMQ(*EXT) TOMSGQ(MOPERQ)
   ENDDO
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
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
             ENDPGM                                                  /*S01117*/
/**END:         ENDPGM                                               /*S01117*/
