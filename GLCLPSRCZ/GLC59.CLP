/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Bal Base Ccy, Consol, Indiv a/c')            */
/********************************************************************/
/*                                                                  */
/*       Midas     General Ledger Module                        */
/*                                                                  */
/*       GLC59 - GL Balances in Base.ccy, consol,indiv a/c level    */
/*                                                                  */
/*       (c) Finastra International Limited 2001                    */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17             */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO. S01408                  DATE 11DEC95        */
/*                      E42846                  DATE 16JUL92        */
/*                      S01194                  DATE  16/03/89      */
/*                      S01117                  DATE  02/03/89      */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                             */
/*       S01408  -  Core hook added for GLC59001                    */
/*               -  Core hook added for GLC59002                    */
/*               -  Core hook added for GLC59INT                    */
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
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RUNTYPE) TYPE(*CHAR) LEN(1)    /*E42846*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
/**********  DCL        VAR(&GLEX)   TYPE(*DEC) LEN(3 0) VALUE(041)*/ /*S01117*/
/**********  DCL        VAR(&GLSTAT) TYPE(*CHAR) LEN(256)         */  /*S01117*/
/**/
/*/COPY WNCPYSRC,GLC59INT                                             /*S01408*/
/*           SNDPGMMSG  MSG('GLC59 - On Request reporting') +   */    /*S01117*/
/*                        TOMSGQ(MRUNQ)                         */    /*S01117*/
             SNDPGMMSG  MSG('GLC59 - GL Balances in Base Ccy, +
                          consolidated, at Indiv.A/c level') +
                          TOMSGQ(MRUNQ)                               /*S01117*/
/**/
/**********  RTVDTAARA  DTAARA(GLSTAT) RTNVAR(&GLSTAT)            */  /*S01117*/
/**/
             CHGJOB     SWS(0001XXX0)
/**/
/**********  IF         COND(%SUBSTRING(&GLSTAT &GLEX 1) = 'N') + */  /*S01117*/
/**********               THEN(CALL PGM(GLC50))                   */  /*S01117*/
/**/
/**********  IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)          */  /*S01117*/
/**/
                OVRDBF     FILE(SGLEX) TOFILE(GLX12)
/***********    OVRDBF     FILE(TABLE) TOFILE(TABGL)*/                /*S01194*/
/***************CALL       PGM(GL0740)*/                              /*S01117*/
/**********     CALL       PGM(GL0740) PARM(&RSEQ &RENT)      *S01117* *E42846*/
/*/COPY WNCPYSRC,GLC59001                                             /*S01408*/
                CALL       PGM(GL0740) PARM(&RUNTYPE &RSEQ &RENT)     /*E42846*/
/*/COPY WNCPYSRC,GLC59002                                             /*S01408*/
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
                          Finastra International Limited')
             ENDPGM
