/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Setup next working day')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas     - System Control Module                           */
/*                                                                   */
/*       SCC2453 - PROCESS NEXT WORKING DAY                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01495             DATE 01OCT94              */
/*       PREV AMEND NO. 046763             DATE 07MAY93              */
/*                      S01375                  03APR92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       S01495 - COB Enhancements.                                  */
/*       046763 - Check Input Cycle Initiation not AUTOCOB           */
/*       S01375 - Auto COB amendments                                */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/* Copyright statement defination  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/* File of on-request reports  */
/**/
/************DCL        VAR(&KEYVAR) TYPE(*CHAR) LEN(4)            */ /*S01495*/
/************DCL        VAR(&CNL) TYPE(*CHAR) LEN(1)               */ /*S01495*/
/************DCL        VAR(&AUTO_COB) TYPE(*CHAR) LEN(1)          */ /*S01495*/
             DCL        VAR(&CB_RTN_CDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CB_AUTO) TYPE(*CHAR) LEN(111)
/**/
/* Global error trap                         */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                        EXEC(GOTO ABNORMAL)
/**/
/* Copyright statement defination at runtime */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
             SNDPGMMSG  MSG('Process Auto COB next working day') +
                          TOMSGQ(MOPERQ)                             /*S01495*/
/*/COPY WNCPYSRC,SCC2453001                                          */
/*                        TOMSGQ(MOPERQ MRUNQ)                  */   /*S01495*/
/**/
             CHGVAR    VAR(%SST(&CB_AUTO 1 10)) VALUE('*TODAY    ')
             CALL      PGM(CB0602X) PARM(&CB_RTN_CDE &CB_AUTO)
/************IF         COND(%SST(&CB_AUTO 66 4) *EQ '*NO ') THEN(DO)/*046763*/
/************IF         COND(%SST(&CB_AUTO 16 5) *EQ +      */ /*046763 S01495*/
/************             '*STOP') THEN(DO)                        */ /*S01495*/
/*******************************************************************/ /*S01495*/
/**Call*CB0602U*to*update*COB*data*fields*on*CBAICDPD***************/ /*S01495*/
/**Reset*fields*for*COB*run*****************************************/ /*S01495*/
/*******************************************************************/ /*S01495*/
/************CHGVAR    VAR(%SST(&CB_AUTO 1 10)) VALUE('*SETDATE  ')*/ /*S01495*/
/************CHGVAR    VAR(%SST(&CB_AUTO 97 7)) VALUE('       ')   */ /*S01495*/
/************CHGVAR    VAR(%SST(&CB_AUTO 104 3)) VALUE(X'00000F')  */ /*S01495*/
/************CALL      PGM(CB0602U) PARM(&CB_RTN_CDE &CB_AUTO)     */ /*S01495*/
 
/************ENDDO                                                 */ /*S01495*/
/************ELSE       CMD(DO)                                    */ /*S01495*/
/**/
/* Display date program */
/**/
 ENTER:      OVRDBF     FILE(TABLE) TOFILE(TABSDU)
             CHGJOB     SWS(XXXXXX0X)
/*/COPY WNCPYSRC,SCC2453002                                          */
             CALL       PGM(SD1020)
/*/COPY WNCPYSRC,SCC2453003                                          */
             DLTOVR     FILE(TABLE)
/**/                                                                  /*S01495*/
/** Error                                                          */ /*S01495*/
/**/                                                                  /*S01495*/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO +
                          CMDLBL(ABNORMAL))                           /*S01495*/
/*******************************************************************/ /*S01495*/
/************IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)           */ /*S01495*/
/*******************************************************************/ /*S01495*/
/************   SNDPGMMSG  MSG('Invalid date entered - do you +    */ /*S01495*/
/************               wish to re-try (Y,N)') TOPGMQ(*EXT) +  */ /*S01495*/
/************               MSGTYPE(*INQ) KEYVAR(&KEYVAR)          */ /*S01495*/
/************   RCVMSG     MSGKEY(&KEYVAR) WAIT(*MAX) +            */ /*S01495*/
/************              KEYVAR(&KEYVAR) MSG(&CNL)               */ /*S01495*/
/*******************************************************************/ /*S01495*/
/************   IF         COND((&CNL *EQ 'Y') *OR (&CNL *EQ 'y'))+*/ /*S01495*/
/************              THEN(GOTO CMDLBL(ENTER))                */ /*S01495*/
/*******************************************************************/ /*S01495*/
/************   CHGJOB     SWS(XXXXXX0X)                           */ /*S01495*/
/************   SNDMSG     MSG('*** Invalid Next working date +    */ /*S01495*/
/************              Entered ***   - A valid date will have +*/ /*S01495*/
/************              to be entered at i/c initiation') +     */ /*S01495*/
/************              TOMSGQ(MOPERQ MRUNQ)                    */ /*S01495*/
/*******************************************************************/ /*S01495*/
/**Call*CB0602U*to*update*COB*data*fields*on*CBAICDPD***************/ /*S01495*/
/**Reset*fields*for*COB*run*****************************************/ /*S01495*/
/*******************************************************************/ /*S01495*/
/************CHGVAR    VAR(%SST(&CB_AUTO 1 10)) VALUE('*SETDATE  ')*/ /*S01495*/
/************CHGVAR    VAR(%SST(&CB_AUTO 97 7)) VALUE('       ')   */ /*S01495*/
/************CHGVAR    VAR(%SST(&CB_AUTO 104 3)) VALUE(X'00000F')  */ /*S01495*/
/************CALL      PGM(CB0602U) PARM(&CB_RTN_CDE &CB_AUTO)     */ /*S01495*/
 
/************ENDDO                                                 */ /*S01495*/
/************ENDDO                                                 */ /*S01495*/
 /**/
             GOTO       CMDLBL(ENDCLPGM)
/**/
/**/
/**************************************************************/
/*                                                            */
/* A B N O R M A L   T E R M I N A T I O N                    */
/*                                                            */
/**************************************************************/
ABNORMAL:
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CALL       PGM(SCC2450)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program SCC2453 ended abnormally') +
                          TOMSGQ(MOPERQ)                              /*S01495*/
/*                        TOMSGQ(MOPERQ MRUNQ)      */                /*S01495*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   ENDPGM
