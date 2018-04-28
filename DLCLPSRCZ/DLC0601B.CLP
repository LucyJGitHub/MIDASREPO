/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL list of todays Deal Amendments')             */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0601B - LIST OF TODAYS DEAL AMENDMENTS                  */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. E47380                  DATE   1FEB93       */
/*       PREV AMEND NO. S01117                  DATE  13/07/89      */
/*            AMEND NO. S01194                  DATE  13/07/89      */
/*            AMEND NO. E18                     DATE  30OCT89       */
/*                                                                  */
/*   E47380 - SHOULD BE AVAILABLE ON REQUEST IN INPUT CYCLE         */
/*   S01117 - MULTIBRANCHING (INCLUDING RCF) CHANGES                */
/*   S01194 - NEW STANDING DATA FILES                               */
/*   E18    - REMOVE CALLING PARAMETERS                             */
/********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */        /*S01117*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch)/*S01117*/
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
 
 
/* THESE ARE MANDATORY REPORTS SO PARMS ARE PASSED HARD CODED HERE */
             CHGVAR     VAR(&RENT) VALUE('ALL')                       /*S01117*/
             CHGVAR     VAR(&RSEQ) VALUE('     ')                     /*S01117*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*   LIST OF TODAYS DEAL AMENDMENTS                            */
             RTVJOBA    SWS(&SWS)
             CHGVAR     VAR(&SWS) VALUE('00000000')
             CHGJOB     SWS(&SWS)
/*********** OVRDBF     FILE(TABLE) TOFILE(TABDLEE)                   /*S01194*/
             SNDPGMMSG  MSG('LIST OF TODAYS DEAL AMENDMENTS') +
                        TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/************CALL       PGM(DL0215)                                   /*S01117*/
/************CALL       PGM(DL0215) PARM(&RSEQ &RENT)         /*E18     S01117*/
/************CALL       PGM(DL0215)                              *E18* *E47380*/
             CALL       PGM(DL0215) PARM(&RSEQ &RENT)                 /*E47380*/
/************DLTOVR     FILE(*ALL)                                    /*S01194*/
/**/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                SNDPGMMSG  MSG('JOB TERMINATED-DATABASE IN ERROR') +
                           TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             ENDDO
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                SNDPGMMSG  MSG('FILE CONTROLS OUT OF BALANCE') +
                           TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             ENDDO
             ENDPGM
