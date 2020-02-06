/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Manaul Adjustments to Accrued Int.')         */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0601C - MANUAL ADJUSTMENTS TO ACCRUED INTEREST          */
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
/*       Prev Amend No. E47380             Date 1FEb93               */
/*                      S01117             Date 13/07/89             */
/*            AMEND NO. S01194                  DATE  13/07/89      */
/*            AMEND NO. E18                     DATE  30OCT89       */
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*   E47380 - SHOULD BE AVAILABLE ON REQUEST IN INPUT CYCLE         */
/*   S01117 - MULTIBRANCHING (INCLUDING RCF) CHANGES                */
/*   S01194 - NEW STANDING DATA FILES                               */
/*   E18    - REMOVE CALLING PARAMETERS                             */
/*                                                                  */
/********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */        /*S01117*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch)/*S01117*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/* THESE ARE MANDATORY REPORTS SO PARMS ARE PASSED HARD CODED HERE */
             CHGVAR     VAR(&RENT) VALUE('ALL')                       /*S01117*/
             CHGVAR     VAR(&RSEQ) VALUE('     ')                     /*S01117*/
 
 
/*   MANUAL ADJUSTMENTS TO ACCRUED INTEREST REPORT                */
             SNDPGMMSG  MSG('MANUAL ADJUSTMENTS TO ACCRUED INTEREST +
                        REPORT') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
             RTVJOBA    SWS(&SWS)
             CHGVAR     VAR(&SWS) VALUE('00000000')
             CHGJOB     SWS(&SWS)
/*********** OVRDBF     FILE(TABLE) TOFILE(TABDLEE)                   /*S01194*/
/************CALL       PGM(DL0220)                                   /*S01117*/
/************CALL       PGM(DL0220) PARM(&RSEQ &RENT)         /*E18     S01117*/
/************CALL       PGM(DL0220)                              *E18* *E47380*/
             CALL       PGM(DL0220) PARM(&RSEQ &RENT)                 /*E47380*/
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
