/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Bal HO Ccy, by Br, GL level')                */
/********************************************************************/
/*                                                                  */
/*       Midas     General Ledger Module                        */
/*                                                                  */
/*       GLC76 - GL Balances in H.O.ccy, by br, GL level            */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01408             Date 04Jan96              */
/*                      E42846             Date 16Jul92              */
/*                      LN0529             DATE  9AUG90             */
/*                      S01194                  DATE  16/03/89      */
/*                      S01117                  DATE  02/03/89      */
/*                      E8449                   DATE  28/03/84      */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       S01408 - Addition of core hook GLC76INT                    */
/*                Addition of core hook GLC76001                    */
/*                Addition of core hook GLC76002                    */
/*       E42846  -  PRODUCE TEXT ON GL0750                          */
/*       LN0529  -  IF ONE BRANCH REQUESTED STOP EXTRACT AT END OF  */
/*                  BRANCH, SO PASS ON PARAMETER.                   */
/*       S01194  -  NEW STANDING DATA                               */
/*       S01117  -  MULTIBRANCHING                                  */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*           PGM                                                        S01117*/
/*********   PGM        PARM(&RSEQ &RENT)                     *S01117* *E42846*/
             PGM        PARM(&RUNTYPE &RSEQ &RENT)                    /*E42846*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RUNTYPE) TYPE(*CHAR) LEN(1)    /*E42846*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC76INT                                             /*S01408*/
                                                                      /*S01408*/
/**/
/*           Offsets for file indicators in the GLSTAT data area     */
/**/
/**********  DCL        VAR(&GLEX) TYPE(*DEC) LEN(3 0) VALUE(041) */  /*S01117*/
/**********  DCL        VAR(&GLSTAT) TYPE(*CHAR) LEN(256)         */  /*S01117*/
/**/
/*           SNDPGMMSG  MSG('GLC76 - On Request reporting') +   */    /*S01117*/
/*                        TOMSGQ(MRUNQ)                         */    /*S01117*/
             SNDPGMMSG  MSG('GLC76 - GL Balances in H.O. Ccy, +
                          by branch, at GL level') +
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
                CLRPFM     FILE(GLX16)                               /*E8449*/
/***************CALL       PGM(GL0745)*/                             /*LN0529*/
                CALL       PGM(GL0745)  PARM(&RENT)                  /*LN0529*/
/**/
                OVRDBF     FILE(SGLEX) TOFILE(GLX16)
/***********    OVRDBF     FILE(TABLE) TOFILE(TABGL)*/                /*S01194*/
/***********    OVRDBF     FILE(TABCHN) TOFILE(TABGL) SHARE(*NO)*/    /*S01194*/
/*              CALL       PGM(GL0750)                                  S01117*/
/**********     CALL       PGM(GL0750) PARM(&RSEQ &RENT)      *S01117* *E42846*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC76001                                             /*S01408*/
                                                                      /*S01408*/
                CALL       PGM(GL0750) PARM(&RUNTYPE &RSEQ &RENT)     /*E42846*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC76002                                             /*S01408*/
                                                                      /*S01408*/
/***********    DLTOVR     FILE(SGLEX TABLE TABCHN)*/                 /*S01194*/
                DLTOVR     FILE(SGLEX)                                /*S01194*/
/**/
/***********    IF         COND(%SWITCH(XXXXXXX1)) THEN(SNDPGMMSG +*/ /*S01194*/
/***********                 MSG('FILE OUT OF BALANCE - SGLEX') +  */ /*S01194*/
/***********                 TOMSGQ(MOPERQ MRUNQ))                 */ /*S01194*/
/**/                                                                  /*S01194*/
                IF         COND(%SWITCH(XXXXXX01)) THEN(SNDPGMMSG +
                             MSG('FILE OUT OF BALANCE - SGLEX') +
                             TOMSGQ(MOPERQ MRUNQ))
/**/                                                                  /*S01194*/
/**/
/**********  ENDDO                                                */  /*S01117*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
