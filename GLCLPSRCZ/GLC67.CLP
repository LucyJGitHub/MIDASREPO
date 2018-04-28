/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Bal HO Ccy, by Br, Indiv a/c')               */
/********************************************************************/
/*                                                                  */
/*       Midas     General Ledger Module                        */
/*                                                                  */
/*       GLC67 - GL Balances in H.O.ccy, by br, indiv a/c level     */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01408             DATE 05JAN96             */
/*       PREV AMEND NO. E42846             DATE 16JUL92             */
/*                      S01194             DATE 16/03/89            */
/*                      S01117             DATE 02/03/89            */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       S01408 - Addition of core hook GLC67INT                    */
/*                Addition of core hook GLC67001                    */
/*                Addition of core hook GLC67002                    */
/*       E42846  -  PRODUCE TEXT ON GL0740                          */
/*       S01194  -  NEW STANDING DATA                               */
/*       S01117  -  MULTIBRANCHING                                  */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM*/                                                    /*S01117*/
/*********   PGM        PARM(&RSEQ &RENT)                     *S01117* *E42846*/
             PGM        PARM(&RUNTYPE &RSEQ &RENT)                    /*E42846*/
/**/
/*           Offsets for file indicators in the GLSTAT data area     */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RUNTYPE) TYPE(*CHAR) LEN(1)    /*E42846*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
/**********  DCL        VAR(&GLEX) TYPE(*DEC) LEN(3 0) VALUE(041) */  /*S01117*/
/**********  DCL        VAR(&GLSTAT) TYPE(*CHAR) LEN(256)         */  /*S01117*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC67INT                                             /*S01408*/
                                                                      /*S01408*/
/**/
/*           SNDPGMMSG  MSG('GLC67 - On Request reporting') +   */    /*S01117*/
/*                        TOMSGQ(MRUNQ)                         */    /*S01117*/
             SNDPGMMSG  MSG('GLC67 - GL Balances in H.O. Ccy, +
                          by branch, at Indiv.A/c level') +
                          TOMSGQ(MRUNQ)                               /*S01117*/
/**/
/**********  RTVDTAARA  DTAARA(GLSTAT) RTNVAR(&GLSTAT)            */  /*S01117*/
/**/
             CHGJOB     SWS(0100XXX0)
/**/
/**********  IF         COND(%SUBSTRING(&GLSTAT &GLEX 1) = 'N') + */  /*S01117*/
/**********               THEN(CALL PGM(GLC50))                   */  /*S01117*/
/**/
/**********  IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)          */  /*S01117*/
/**/
                OVRDBF     FILE(SGLEX) TOFILE(GLX11)
/***********    OVRDBF     FILE(TABLE) TOFILE(TABGL)*/                /*S01194*/
/***************CALL       PGM(GL0740)*/                              /*S01117*/
/**********     CALL       PGM(GL0740) PARM(&RSEQ &RENT)      *S01117* *E42846*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC67001                                             /*S01408*/
                                                                      /*S01408*/
                CALL       PGM(GL0740) PARM(&RUNTYPE &RSEQ &RENT)     /*E42846*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC67002                                             /*S01408*/
                                                                      /*S01408*/
/***********    DLTOVR     FILE(SGLEX TABLE)*/                        /*S01194*/
                DLTOVR     FILE(SGLEX)                                /*S01194*/
/**/
/***********    IF         COND(%SWITCH(XXXXXXX1)) THEN(SNDPGMMSG +*/ /*S01194*/
/***********                 MSG('FILE OUT OF BALANCE - SGLEX') +*/   /*S01194*/
/***********                 TOMSGQ(MOPERQ MRUNQ))*/                  /*S01194*/
/*BEGIN*/                                                             /*S01194*/
                IF         COND(%SWITCH(XXXXXX01)) THEN(SNDPGMMSG +
                             MSG('FILE OUT OF BALANCE - SGLEX') +
                             TOMSGQ(MOPERQ MRUNQ))
/*END*/                                                               /*S01194*/
/**/
/**********  ENDDO                                                */  /*S01117*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
