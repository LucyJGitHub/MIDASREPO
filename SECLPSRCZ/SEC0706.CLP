/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Security Setl Projection by Depot')          */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*       SEC0706 - SECURITY SETTLEMENT PROJECTION BY DEPOT          */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. E29108                  DATE  02OCT91       */
/*       PREV AMEND NO. S01117                  DATE  10DEC90       */
/*                      S01179                  DATE  16/09/88      */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*         E29108 - OVERRIDE FOR BRANCH ENTITY INCORRECT            */
/*         S01117 - MULTIBRANCHING                                  */
/*         S01179 -     RELEASE                                     */
/*                                                                  */
/********************************************************************/
 
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*           PGM                                                   */ /*S01117*/
             PGM        PARM(&RSEQ &RLEV &RENT)                       /*S01117*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
             DCL        VAR(&MBIN) TYPE(*CHAR) LEN(1)                 /*S01117*/
/* S01179                                                              *S01179*/
/*********   DCLDTAARA  DTAARA(LDA)                          ********  *S01179*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*S01179*/
 
/*           DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
 
/* SEND PGM MESSAGE */
 
             CHGVAR     VAR(&MSG) VALUE('SEC0706 - Security +
                          Settlement Projection by Depot')
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
 
/**/                                                                  /*S01117*/
/* OBTAIN MULTIBRANCH INDICATOR */                                    /*S01117*/
/**/                                                                  /*S01117*/
             RTVDTAARA  DTAARA(RUNDAT (13 1)) RTNVAR(&MBIN)           /*S01117*/
/**/                                                                  /*S01117*/
/* SET UP OVRDBF  */                                                  /*S01117*/
/**/                                                                  /*S01117*/
     IF       COND(&MBIN *EQ 'Y' *AND &RENT *NE 'ALL') THEN(DO)       /*S01117*/
/*********OVRDBF  FILE(DPEVE1) POSITION(*KEYAE 1 &RENT) */ /*S01117*/ /*E29108*/
             OVRDBF     FILE(DPEVE1) POSITION(*KEYAE 1 *N &RENT)      /*E29108*/
              ENDDO                                                   /*S01117*/
/**/                                                                  /*S01117*/
/* TEST FOR FILE OVERRIDES */                                         /*S01117*/
/**/                                                                  /*S01117*/
             OPNDBF     FILE(DPEVE1) OPTION(*ALL)                     /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
             DLTOVR     FILE(*ALL)                                    /*S01117*/
             MONMSG     MSGID(CPF9841)                                /*S01117*/
             ENDDO                                                    /*S01117*/
/**/                                                                  /*S01117*/
/* CLEAR SWITCHES */
 
             CHGJOB     SWS(00000000)
 
/* CALL REPORT PROGRAM */
 
/*              CALL       PGM(SE0840)                             */ /*S01117*/
                CALL       PGM(SE0840) PARM(&RSEQ &RENT)              /*S01117*/
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
 
ERROR:       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/* S01179                                                              *S01179*/
/*********      RCVDTAARA  DTAARA(LDA)                      *********  *S01179*/
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                   /*S01179*/
/*              CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))*/ /*S01117*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))   /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
                CHGVAR     VAR(&MEM) VALUE('SEC0706 - Database Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
/* FILE CONTROLS OUT OF BALANCE */
 
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
               CHGVAR    VAR(&MEM) VALUE('SEC0706 - File Controls Out +
                          of Balance')
               SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
             RCLRSC                                                   /*S01117*/
             DLTOVR     FILE(*ALL)                                    /*S01117*/
             MONMSG     MSGID(CPF9841)                                /*S01117*/
/*END:********ENDPGM                                                 * *S01117*/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01117*/
