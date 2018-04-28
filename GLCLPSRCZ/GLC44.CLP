/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Accounts Opened by the System')              */
/********************************************************************/
/*                                                                  */
/*        Midas     - General Ledger Module                     */
/*                                                                  */
/*       GLC44 - ACCOUNTS OPENED BY THE SYSTEM                      */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO.- BHF798                DATE - 25APR91       */
/*       PREV AMEND NO.- S01194                DATE - 16/03/89      */
/*       PREV AMEND NO.- S01117                DATE - 01/03/89      */
/*                       E0254                 DATE - 22/02/85      */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       BHF798  -  CLOF ALL OPNDBF AT END OF PGM                   */
/*       S01194  -  NEW STANDING DATA                               */
/*       S01117  -  MULTIBRANCHING                                  */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                   */ /*S01117*/
             PGM  (&RSEQ &RLEV &RENT)                                 /*S01117*/
/**/                                                                  /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
/**/
/***     FOLLOWING MESSAGE TEXT AMENDED, ERROR E0254                */ /*E0254*/
/***         SNDPGMMSG  MSG('GLC43 - Accounts Opened by the System') +        */
             SNDPGMMSG  MSG('GLC44 - Accounts Opened by the System') +
                        TOMSGQ(MRUNQ)
/**/
             CHGJOB     SWS(00000000)
/**/
/*********** OVRDBF     FILE(TABLE) TOFILE(TABGL)*/                   /*S01194*/
/*********** OVRDBF     FILE(TABLED) TOFILE(TABGL) SHARE(*NO)*/       /*S01194*/
/*********** CALL       PGM(GL0440)                                */ /*S01117*/
             IF         COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                          THEN(DO)                                    /*S01117*/
                          OVRDBF FILE(ACOP) POSITION(*KEY 1 +
                          SYSOPAJF &RENT)                             /*S01117*/
                          OPNDBF FILE(ACOP) OPTION(*ALL)              /*S01117*/
                          MONMSG MSGID(CPF0000) EXEC(DO)              /*S01117*/
                          DLTOVR FILE(ACOP)                           /*S01117*/
                          ENDDO                                       /*S01117*/
                          ENDDO                                       /*S01117*/
             CALL       PGM(GL0440) PARM(&RSEQ &RENT)                 /*S01117*/
             DLTOVR     FILE(ACOP)                                    /*S01117*/
             MONMSG     MSGID(CPF9841)                                /*S01117*/
             CLOF       OPNID(ACOP)                                   /*BHF798*/
             MONMSG     MSGID(CPF0000)                                /*BHF798*/
/*********** DLTOVR     FILE(TABLE TABLED)*/                          /*S01194*/
/**/
/*********** IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)*/            /*S01194*/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)              /*S01194*/
/**/
                SNDPGMMSG  MSG('FILE OUT OF BALANCE - ACOP') +
                             TOMSGQ(MRUNQ)
                SNDPGMMSG  MSG('FILE OUT OF BALANCE - ACOP') +
                             TOMSGQ(MOPERQ)
/**/
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
