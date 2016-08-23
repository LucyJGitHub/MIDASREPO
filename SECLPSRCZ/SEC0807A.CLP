/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Client Report by Customer Number')           */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*       SEC0807A  CLIENT REPORT - NUMBER ORDER                     */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01117                  DATE  09JAN91       */
/*       PREV AMEND NO. E23408                  DATE  06SEP90       */
/*                      S01179                  DATE  16/09/88      */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*     S01117 - MULTIBRANCHING                                      */
/*     E23408 - CHECK ON DEALING AND RETAIL REDUNDANT - U1 IS SET   */
/*              ON IN THIS PROGRAM TO PRODUCE REPORT IN CUSTOMER NO */
/*              ORDER, U2 IS SET ON IN SEC0807B TO PRODUCE REPORT   */
/*              IN SHORTNAME ORDER.                                 */
/*     S01179 - RELEASE                                         */
/*                                                                  */
/********************************************************************/
 
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM                                                     * *S01117*/
             PGM        PARM(&RSEQ &RLEV &RENT)                       /*S01117*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
/* S01179                                                              *S01179*/
/*********   DCLDTAARA  DTAARA(LDA)                          ********  *S01179*/
/* S01179                                                              *S01179*/
/*********   DCLDTAARA  DTAARA(MMOD)                         ********  *S01179*/
 
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)               * *S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
/************DCL********VAR(&DL)  TYPE(*CHAR) LEN(1)                 *E23408*/
/************DCL********VAR(&RT)  TYPE(*CHAR) LEN(1)                 *E23408*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
 
/* SETUP AND SEND PGM MESSAGE                                    */
 
             CHGVAR     VAR(&MEM) VALUE('SEC0807A  - Client Report')
 
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* CLEAR SWITCHES                                                */
 
             CHGJOB SWS(10000000)
 
/* CALL PROGRAM                                                  */
 
/************CALL       PGM(SE1100)                                  * *S01117*/
             CALL       PGM(SE1100) PARM(&RSEQ)                       /*S01117*/
 
/* RESET SWITCHES                                                */
 
             CHGJOB SWS(000000XX)
 
/*  REDUNDANT CODE                                                   *E23408*/
/***************RTVDTAARA  DTAARA(MMOD (2 1)) RTNVAR(&DL)*************E23408*/
/************IF*********COND(&DL *EQ 'Y') THEN(CHGJOB SWS(X1XXXXXX))*+E23408*/
/*************************** Dealing module present ******************E23408*/
/***************RTVDTAARA  DTAARA(MMOD (16 1)) RTNVAR(&RT)************E23408*/
/************IF*********COND(&RT *EQ 'Y') THEN(CHGJOB SWS(1XXXXXXX)) +E23408*/
/*************************** Retail module present *******************E23408*/
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)         * *S01117*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
                CHGVAR    VAR(&MEM) VALUE('SEC0807  - Job Terminated, +
                          Database in Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/* FOR FILE CONTROLS OUT OF BALANCE ERROR                        */
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                CHGVAR  VAR(&MEM) VALUE('SEC0807  - File Controls Out +
                        Of Balance')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
/*ENDPGM:******ENDPGM                                                * *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01117*/
