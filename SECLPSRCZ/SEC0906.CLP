/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Monthly Trading Reconciliation')             */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*       SEC0906 - MONTHLY TRADING RECONCILIATION                   */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. E35724                  DATE  11FEV92       */
/*       PREV AMEND NO. S01117                  DATE  10JAN91       */
/*                      S01179                  DATE  16/09/88      */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*         E35724 - No override to value date file if value date    */
/*                  report and branch ALL is requested.             */
/*         S01117 - MULTIBRANCHING                                  */
/*         S01179 -     RELEASE                                     */
/*                                                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
/*PGM        PARM(&PARM)                                             * *S01117*/
             PGM        PARM(&PARM &RSEQ &RLEV &RENT)                 /*S01117*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
/* S01179                                                              *S01179*/
/*********   DCLDTAARA  DTAARA(LDA)                          ********  *S01179*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*S01179*/
 
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)               * *S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
 
/*  SETUP AND SEND PGM MESSAGE                                      */
 
             CHGVAR     VAR(&MEM) VALUE('SEC0906  - Monthly Trading +
                          Reconciliation')
 
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/*     RESET SWITCHES                                               */
 
             CHGJOB     SWS(00000000)
 
/*   CALL REPORT PROGRAM                        */
 
 
/*       POSITION FILE TO THE PARTICULAR BRANCH                      * *S01117*/
           IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) THEN(DO) /*S01117*/
             OVRDBF     FILE(SESLTD) POSITION(*KEY 1 SESLTDF &RENT)   /*S01117*/
/************IF        COND(&PARM *EQ 'V') THEN(OVRDBF FILE(BPOHTR) +* *S01117*/
/************             TOFILE(BPOHVL))                            * *S01117*/
             IF         COND(&PARM *EQ 'V') THEN(OVRDBF FILE(BPOHTR) +
                          TOFILE(BPOHVL) POSITION(*KEY 1 BKPHDDF +
                          &RENT))                                     /*S01117*/
             ELSE       CMD(OVRDBF FILE(BPOHTR) POSITION(*KEY 1 +
                          BKPHDDF &RENT))                             /*S01117*/
             OPNDBF     FILE(BPOHTR) OPTION(*ALL)                     /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
               DLTOVR     FILE(BPOHTR)                                /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(BPOHTR)                                 /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
           ENDDO                                                      /*S01117*/
           ELSE (DO)                                                  /*E35724*/
             IF        COND(&PARM *EQ 'V') THEN(OVRDBF FILE(BPOHTR) +
                          TOFILE(BPOHVL))                             /*E35724*/
           ENDDO                                                      /*E35724*/
 
             IF         COND(&PARM *NE 'V') THEN(OVRDBF FILE(TRDMTH) +
                          TOFILE(TRDMTHT))
 
             IF         COND(&PARM *NE 'V') THEN(OVRDBF FILE(BACPV) +
                          TOFILE(BACPT))
 
/************CALL       PGM(SE0950)                                  * *S01117*/
             CALL       PGM(SE0950) PARM(&RSEQ &RENT)                 /*S01117*/
 
/**/
/*  ABNORMAL TERMINATION MESSAGE - DATABASE ERROR                   */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/* S01179                                                              *S01179*/
/*********   RCVDTAARA  DTAARA(LDA)                         *********  *S01179*/
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                      /*S01179*/
/************CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44))           * *S01117*/
             CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))            /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             SNDPGMMSG  MSG('SEC0906 - Database Error') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
