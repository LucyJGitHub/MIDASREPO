/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT UNCLEARED CHEQUES REPORT')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas      FUNDS TRANSFER MODULE                        */
/*                                                                   */
/*       FTC0600 - UNCLEARED CHEQUES LISTING                         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. E29901         DATE  02APR91                 */
/*       PREV AMEND NO. S01117         DATE  26MAR91                 */
/*            AMEND NO. S01194         DATE  26MAR91                 */
/*                                                                   */
/*********************************************************************/
/*    E29901 - ROLLBACK STATEMENT REDUNDANT AS NO FILES IN PGM ARE   */
/*             UNDER COMMITMENT CONTROL                              */
/*    S01194 - NEW DATABASE HANDLING                                 */
/*    S01117 - RELEASE 10 MULTIBRANCHING CHANGES                     */
/*********************************************************************/
 
/**START:  PGM        /* CL Program for running Uncleared Cheques +  /*S01117*/
/**                   Listing Program. */                            /*S01117*/
           PGM        PARM(&RSEQ &RLEV &RENT)                        /*S01117*/
/**/
        DCL   VAR(&RSEQ)  TYPE(*CHAR)   LEN(5)                       /*S01117*/
        DCL   VAR(&RLEV)  TYPE(*CHAR)   LEN(1)                       /*S01117*/
        DCL   VAR(&RENT)  TYPE(*CHAR)   LEN(3)                       /*S01117*/
/**     DCL        VAR(&DATA) TYPE(*CHAR) LEN(44)                    /*S01194*/
        DCL   VAR(&DATA)  TYPE(*CHAR)   LEN(50)                      /*S01194*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                 /*S01194*/
/** Check if LDA Data area exists and create it if not **/           /*S01194*/
/**/                                                                 /*S01194*/
        CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)                         /*S01194*/
        MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                   DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                   VALUE(' ') TEXT('Midas SD LOCAL +
                   DATA AREA EQUIVALENT') AUT(*USE))                 /*S01194*/
        CHGJOB     SWS(XXXXXX00)
/**/                                                                 /*S01117*/
/** set up override **/                                              /*S01117*/
/**/                                                                 /*S01117*/
          IF COND((&RENT *NE 'ALL') *AND (&RENT *NE '   ')) THEN(DO)
             OVRDBF     FILE(UNCHQBB) POSITION(*KEY 1 *N &RENT)
             OPNDBF     FILE(UNCHQBB) OPTION(*INP)
             MONMSG     MSGID(CPF4125) EXEC(OVRDBF FILE(UNCHQBB) +
                          POSITION(*END))
             ENDDO                                                   /*S01117*/
/**/
/***************************************************/
/**  Call Program & Monitor for Untrapped Errors  **/
/***************************************************/
/**/
/**     CALL       PGM(FT0600)                                       /*S01117*/
        CALL       PGM(FT0600) PARM(&RSEQ &RLEV &RENT 'B')           /*S01117*/
        MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
/**                ROLLBACK                                          /*E29901*/
                   SNDPGMMSG  MSG('Transaction Failed. +
                                   Re-input Necessary. +
                                   Press Enter to Continue.') +
                              TOPGMQ(*EXT)
                   GOTO END
        ENDDO
/**/
/****************************************************/
/**  Check for Database Errors Trapped by Program  **/
/****************************************************/
/**/
        IF COND(%SWITCH(XXXXXX11)) THEN(DO)
/**        ROLLBACK                                                  /*E29901*/
/**        RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&DATA)             /*S01194*/
           RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)             /*S01194*/
           SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                      TOPGMQ(*EXT) TOMSGQ(MOPERQ)
        ENDDO
/**/
/** END:    ENDPGM                                                   /*S01117*/
END:                                                                 /*S01117*/
/**/                                                                 /*S01117*/
/** delete override **/                                              /*S01117*/
/**/                                                                 /*S01117*/
             DLTOVR     FILE(UNCHQBB)                                /*S01117*/
             MONMSG     MSGID(CPF9841)                               /*S01117*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
        ENDPGM                                                       /*S01117*/
