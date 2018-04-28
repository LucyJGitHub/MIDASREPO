/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT Outgoing Payments Maint. Level 2')           */
/********************************************************************/
/*                                                                  */
/*       Midas     STANDING DATA                                    */
/*                                                                  */
/*       FTC0045  - CL COMPONENT TO CONTROL FT0045                  */
/*                  OUTGOING PAYMENTS MAINTENANCE LEVEL 2           */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Last Amend No. CFT009             DATE 30Apr01             */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CAC001             DATE 01FEB96             */
/*                      S01435             DATE 06NOV93             */
/*                      042167             DATE 15APR93             */
/*                      S01194            DATE  17/07/90            */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       CFT009 - Funds Transer Fees and Charges                    */
/*       CAC001 - Profit Centre Accounting Development:             */
/*                Provide a blank sixth parameter, for margin info  */
/*                data, when calling FTC0310 to avoid runtime error.*/
/*       S01435 - Link to new program FTC0310                       */
/*       042167 - CL PROGRAM FOR RECORD LOCKING                     */
/*       S01194 - NEW DATABASE ERROR HANDLING                       */
/********************************************************************/
             PGM        PARM(&ACTION &PREF &COMMAND &LINK)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(1) /* Action +
                          code. */
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(15) /* Payment +
                          reference. */
             DCL        VAR(&COMMAND) TYPE(*CHAR) LEN(1) /* Command +
                          key. */
             DCL        VAR(&LINK) TYPE(*CHAR) LEN(1) /* Linkage +
                          = Y if called from FT0045 .  */
 
/*           DCL        VAR(&DATA) TYPE(*CHAR) LEN(44)         */    /*S01194*/
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)               /*S01194*/
                                                                      /*042167*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)               /*042167*/
             DCL        VAR(&MODULE) TYPE(*CHAR) LEN(2)               /*042167*/
             DCL        VAR(&TRNREF) TYPE(*CHAR) LEN(15)              /*042167*/
             DCL        VAR(&RINFOR) TYPE(*CHAR) LEN(80)              /*042167*/
             DCL        VAR(&PREF2)  TYPE(*CHAR) LEN(15)              /*042167*/
             DCL        VAR(&FT_CNTRL) TYPE(*CHAR) LEN(64)            /*S01435*/
             DCL        VAR(&MINFO)  TYPE(*CHAR) LEN(14) +
                          VALUE(*BLANKS)                              /*CAC001*/
             DCL        VAR(&FLAG12) TYPE(*CHAR) LEN(1)               /*CFT009*/
/*/COPY WNCPYSRC,FTC0045003                                          */
 
             CHGJOB     SWS(XXXXXX00)
                                                                      /*042167*/
             CHGVAR     VAR(&PREF2) VALUE(&PREF)                      /*042167*/
/* */                                                                 /*S01435*/
/* Link to new FT CL controlling component */                         /*S01435*/
/* */                                                                 /*S01435*/
             CHGVAR     VAR(%SST(&FT_CNTRL 1 1)) VALUE(&LINK)         /*S01435*/
/* */                                                                 /*S01435*/
/**********  CALL       PGM(FTC0310) PARM(&RTNCDE 'FT0345    ' +
                          &ACTION &PREF &FT_CNTRL)  */     /*S01435*/ /*CAC001*/
/*/COPY WNCPYSRC,FTC0045001                                          */
                                                                      /*CFT009*/
/************CALL       PGM(FTC0310) PARM(&RTNCDE 'FT0345    ' +
/************             &ACTION &PREF &FT_CNTRL &MINFO)      /*CAC001 CFT009*/
                                                                      /*CFT009*/
             CALL       PGM(FTC0310) PARM(&RTNCDE 'FT0345    ' +
                          &ACTION &PREF &FT_CNTRL &MINFO &FLAG12)     /*CFT009*/
                                                                      /*CFT009*/
/*/COPY WNCPYSRC,FTC0045002                                          */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)       /*S01435*/
             GOTO       CMDLBL(END)                                   /*S01435*/
             ENDDO                                                    /*S01435*/
/* */                                                                 /*S01435*/
/* If F3 pressed set &COMMAND to "1"       */                         /*S01435*/
/* */                                                                 /*S01435*/
             IF         COND(&RTNCDE *EQ 'Y2U9999') THEN(DO)          /*S01435*/
             CHGVAR     VAR(&COMMAND) VALUE('1')                      /*S01435*/
             ENDDO                                                    /*S01435*/
/* */                                                                 /*S01435*/
/* If F7 pressed set &COMMAND to "7"       */                         /*S01435*/
/* */                                                                 /*S01435*/
             IF         COND(&RTNCDE *EQ 'FTM2005') THEN(DO)          /*S01435*/
             CHGVAR     VAR(&COMMAND) VALUE('7')                      /*S01435*/
             ENDDO                                                    /*S01435*/
/* */                                                                 /*S01435*/
/* If F12 pressed set &COMMAND to "2"      */                         /*S01435*/
/* */                                                                 /*S01435*/
             IF         COND(&RTNCDE *EQ 'USR0790') THEN(DO)          /*S01435*/
             CHGVAR     VAR(&COMMAND) VALUE('2')                      /*S01435*/
             ENDDO                                                    /*S01435*/
/* */                                                                 /*S01435*/
             GOTO       CMDLBL(END)                                   /*S01435*/
/**/
/** Call program & monitor for untrapped errors **/
/**/
/* OVRDBF CLINT SHARE(*NO)                                      */   /*S01194*/
/**/
/*/COPY WNCPYSRC,FTC0045004                                          */
             CALL       PGM(FT0045)  +
                        PARM(&ACTION &PREF &COMMAND &LINK)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
                        ROLLBACK
                        SNDPGMMSG  MSG('Transaction Failed. +
                                        Re-input necessary. +
                                        Press Enter to Continue.') +
                                   TOPGMQ(*EXT)
                        GOTO END
             ENDDO
/**/
/** Check for database errors trapped by program **/
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                ROLLBACK
/*              RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&DATA)   */   /*S01194*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)        /*S01194*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*END:*********ENDPGM**********/                                      /*042167*/
END:                                                                  /*042167*/
/* */                                                                 /*042167*/
/* CALL AOC8000 to release locks if not called from another program*/ /*042167*/
/* */                                                                 /*042167*/
             IF         COND(&PREF2 *EQ *BLANKS) THEN(DO)             /*042167*/
             CHGVAR     VAR(&MODULE) VALUE('FT')                      /*042167*/
             CHGVAR     VAR(&TRNREF) VALUE('               ')         /*042167*/
             CHGVAR     VAR(&RINFOR) VALUE('    ')                    /*042167*/
             CHGVAR     VAR(&RTNCDE) VALUE('       ')                 /*042167*/
             CALL       PGM(AOC8000) PARM(&RTNCDE &MODULE &TRNREF +
                          &RINFOR)                                    /*042167*/
             ENDDO                                                    /*042167*/
/* */
             ENDPGM                                                   /*042167*/
