/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Events by Security')                         */
/********************************************************************/
/*                                                                  */
/*         Midas - Securities Trading Module                    */
/*                                                                  */
/*       SEC0702   EVENTS BY SECURITY                               */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. CSE104             Date 08Aug23              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 11Apr95              */
/*                      S01117             Date 09Jan91              */
/*                      S01179                  DATE  16/09/88      */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       CSE104 - Securities events by Event Date Report             */
/*       MD046248 - Finastra Rebranding                              */
/*         S01408 - CORE HOOK ADDED SEC0702MPS                      */
/*                - CORE HOOK ADDED SEC0702MP1                      */
/*         S01117 - MULTIBRANCHING                                  */
/*         S01179 - ABS RELEASE                                     */
/*                                                                  */
/********************************************************************/

/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM                                                     * *S01117*/
             PGM        PARM(&RSEQ &RLEV &RENT)                       /*S01117*/

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
/* S01179                                                              *S01179*/
/*********   DCLDTAARA  DTAARA(LDA)                          ********  *S01179*/

/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)               * *S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
             DCL        VAR(&CSE104) TYPE(*CHAR) LEN(1)                                   /*CSE104*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CSE104*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                                      /*CSE104*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CSE104*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')                          /*CSE104*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                                    /*CSE104*/

/* SETUP AND SEND PGM MESSAGE                                    */

             CHGVAR     VAR(&MEM) VALUE('SEC0702  - Events +
                        by Security')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ) MSGTYPE(*INFO)

/* CLEAR SWITCHES                                                */

             CHGJOB SWS(00000000)

/* CALL PROGRAM                                                  */

/**/                                                                                      /*CSE104*/
/** Access SAR file to determine if switchable feature CSE104     */                      /*CSE104*/
/**/                                                                                      /*CSE104*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CSE104*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CSE104*/
             CHGVAR     VAR(&SAR) VALUE('CSE104')                                         /*CSE104*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CSE104*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CSE104) VALUE('Y'))                                        /*CSE104*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0702MPS                                          */
                                                                      /*S01408*/
/************CALL       PGM(SE0810)                                 * *S01117*/
             CALL       PGM(SE0810) PARM(&RSEQ &RENT)                /*S01117*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0702MP1                                          */
                                                                      /*S01408*/
             IF         COND(&CSE104 *EQ 'Y') THEN(DO)                                    /*CSE104*/
             OVRDBF     FILE(EVSEC) TOFILE(SEEVSCL0) OVRSCOPE(*JOB)                       /*CSE104*/
             OVRPRTF    FILE(SE0810AU) TOFILE(SE0810A2) OVRSCOPE(*JOB)                    /*CSE104*/
             OVRPRTF    FILE(SE0810P1) TOFILE(SE0810P2) OVRSCOPE(*JOB)                    /*CSE104*/
             CALL       PGM(SE0810) PARM(&RSEQ &RENT)                                     /*CSE104*/
             ENDDO                                                                        /*CSE104*/

/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */

 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)         * *S01117*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
                CHGVAR    VAR(&MEM) VALUE('SEC0702  - Job Terminated, +
                          Database in Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO

/* FOR FILE CONTROLS OUT OF BALANCE ERROR                        */

             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                CHGVAR  VAR(&MEM) VALUE('SEC0702  - File Controls Out +
                        Of Balance')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             ENDDO

/*ENDPGM:******ENDPGM                                                * *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01117*/
