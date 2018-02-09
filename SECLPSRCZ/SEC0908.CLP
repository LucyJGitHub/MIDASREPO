/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Security Ledger Report')                     */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*       SEC0908 - SECURITY LEDGER                                  */
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
/*       Prev Amend No. S01408             Date 1DEc95               */
/*                      S01117             Date 10Jan91              */
/*                      S01179                  DATE  16/09/88      */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*         S01408 - CORE HOOK SEC0908001 ADDED                      */
/*                  CORE HOOK SEC0908002 ADDED                      */
/*         S01117 - MULTIBRANCHING                                  */
/*         S01179 -     RELEASE                                     */
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
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*S01179*/
 
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)               * *S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
 
/* SEND PGM MESSAGE */
 
             CHGVAR     VAR(&MEM) VALUE('SEC0908 - Security Ledger +
                          Report')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ)
 
/* CLEAR OUTPUT FILES */
 
             CLRPFM     FILE(MTRADD)
/************CLRPFM     FILE(SESLTA)                                 * *S01117*/
/************CLRPFM     FILE(SESLTD)                                 * *S01117*/
 
/* EXTRACT MONTHLY TRADE TRANSACTIONS */
 
             CALL       PGM(SE0972)
 
/* IF NO ERRORS PROMPT FOR/PRINT SECURITY LEDGER   */
/*    IF NOT MONTH END PROMPT FOR DETAILS          */
 
/*           IF         COND(%SWITCH(XXX0XX00)) THEN(DO)  */
/*             CHGJOB     SWS(XX1XXXXX)                   */
/*             CALL       PGM(SE0970)                     */
/*           ENDDO                                        */
 
/*****IF*MONTH*END*PRINT*ALL*DETAILS***********                        *S01117*/
/************IF         COND(%SWITCH(XXXXXX00)) THEN(DO)             * *S01117*/
/**************CHGJOB     SWS(00010000)                              * *S01117*/
/**************CALL       PGM(SE0970)                                * *S01117*/
/************ENDDO                                                   * *S01117*/
 
/* IF NO ERRORS RUN SECURITY LEDGER REPORT  */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/*       POSITION FILE TO THE PARTICULAR BRANCH                      * *S01117*/
           IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) THEN(DO) /*S01117*/
             OVRDBF     FILE(DPOSO) POSITION(*KEY 1 DPOSNDF &RENT)    /*S01117*/
             OPNDBF     FILE(DPOSO) OPTION(*ALL)                      /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
               DLTOVR     FILE(DPOSO)                                 /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(DPOSO)                                  /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
           ENDDO                                                      /*S01117*/
 
/*/COPY WNCPYSRC,SEC0908001                                           /*S01408*/
/**************CALL       PGM(SE0975)                                * *S01117*/
               CALL       PGM(SE0975) PARM(&RSEQ &RENT)               /*S01117*/
/*/COPY WNCPYSRC,SEC0908002                                           /*S01408*/
             ENDDO
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
 
ERROR:       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/* S01179                                                              *S01179*/
/*********      RCVDTAARA  DTAARA(LDA)                      *********  *S01179*/
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                   /*S01179*/
/***************CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))  * *S01117*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))   /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
                CHGVAR     VAR(&MEM) VALUE('SEC0908 - Job Terminated, +
                          Database in Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/* FILE CONTROLS OUT OF BALANCE */
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
              CHGVAR     VAR(&MEM) VALUE('SEC0908 - File Controls out +
                          of Balance')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/*ENDPGM:******ENDPGM                                                * *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01117*/
