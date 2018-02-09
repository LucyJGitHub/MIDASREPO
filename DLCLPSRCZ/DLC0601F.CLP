/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Brokerage Rates Report')                     */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0601F - BROKERAGE RATES REPORT                          */
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
/*       Prev Amend No. BHF745             Date 27Sep90              */
/*                      S01117             Date 11/08/89             */
/*                      S01194                  DATE  11/08/89      */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       BHF745 - ADD PARAMETERS SEQUENCE NO.,LEVEL AND ENTITY      */
/*       S01117 - RELEASE 10 MULTIBRANCHING                         */
/*       S01194 - NEW STANDING DATA FILES                           */
/*                                                                  */
/********************************************************************/
/*           PGM                                                       *BHF745*/
             PGM        PARM(&RSEQ &RLVL &RENT)                       /*BHF745*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */        /*S01117*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*BHF745*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*BHF745*/
 
/**THESE*ARE*MANDATORY*REPORTS*SO*PARMS*ARE*PASSED*HARD*CODED*HERE */ /*BHF745*/
/*           CHGVAR     VAR(&RSEQ) VALUE('     ')             *S01117* *BHF745*/
 
/*   BROKERAGE RATES REPORT                                   */
             SNDPGMMSG  MSG('BROKERAGE RATES REPORT') TOMSGQ(MRUNQ) +
                        MSGTYPE(*INFO)
             RTVJOBA    SWS(&SWS)
             CHGVAR     VAR(&SWS) VALUE('00000000')
             CHGJOB     SWS(&SWS)
/************OVRDBF     FILE(TABLE) TOFILE(TABDLEE)                   /*S01194*/
/************CALL       PGM(DL0235)                                   /*S01117*/
             CALL       PGM(DL0235) PARM(&RSEQ)                       /*S01117*/
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
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
