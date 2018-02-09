/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Interest Accruals Report')                   */
/*********************************************************************/
/*                                                                   */
/*         Midas     - Securities Trading Module                */
/*                                                                   */
/*       SEC0901 - INTEREST ACCRUALS REPORT                          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01408             Date 15May96              */
/*                      S01117             Date 10Jan91              */
/*                      E20085             DATE 07NOV89              */
/*                      S01179             DATE 16/09/88             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01408 - Core hook SEC0901003 added.                        */
/*                Core hook SEC0901002 added.                        */
/*                Core hook SEC0901001 added.                        */
/*       S01117 - MULTIBRANCHING                                     */
/*       E20085 - Interest and coupon Calculations Rewrite:          * *E20085*/
/*               - SE0900 Interest Accrual Extract was rewritten     * *E20085*/
/*                 and is now SE0901.                                * *E20085*/
/*       S01179 -  RELEASE                                        * *S01179*/
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM                                                     * *S01117*/
/*/COPY WNCPYSRC,SEC0901008                                          */
             PGM        PARM(&RSEQ &RLEV &RENT)                       /*S01117*/
/*/COPY WNCPYSRC,SEC0901009                                          */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
/* S01179                                                              *S01179*/
/*********   DCLDTAARA  DTAARA(LDA)                          ********  *S01179*/
/*/COPY WNCPYSRC,SEC0901004                                          */
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*S01179*/
/**/
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)               * *S01117*/
/*/COPY WNCPYSRC,SEC0901010                                          */
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
/*/COPY WNCPYSRC,SEC0901005                                          */
/**/
/* SEND PGM MESSAGE */
/**/
             CHGVAR     VAR(&MEM) VALUE('SEC0901 - Interest Accruals +
                          Report')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ)
/**/
/* CLEAR SWITCHES */
/**/
             CHGJOB     SWS(00000000)
/**/
/* CLEAR OUTPUT FILES */
/**/
             CLRPFM     FILE(IACEXD)
             CLRPFM     FILE(IACEXA)
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,SEC0901001                                           /*S01408*/
/*                                                                    /*S01408*/
/**/
/**CALL*SE0900*(EXTRACT)**/                                           /*E20085*/
/* CALL SE0901 (EXTRACT) */                                           /*E20085*/
/**/
/*********** CALL       PGM(SE0900)   */                              /*E20085*/
             CALL       PGM(SE0901)                                   /*E20085*/
/**/
/* IF NO ERRORS CALL SE0905 (REPORT) */
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,SEC0901002                                           /*S01408*/
/*                                                                    /*S01408*/
/*       POSITION FILE TO THE PARTICULAR BRANCH                      * *S01117*/
           IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) THEN(DO) /*S01117*/
             OVRDBF     FILE(IACEX) POSITION(*KEY 1 IACEXDF &RENT)    /*S01117*/
             OPNDBF     FILE(IACEX) OPTION(*ALL)                      /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
               DLTOVR     FILE(IACEX)                                 /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(IACEX)                                  /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
           ENDDO                                                      /*S01117*/
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,SEC0901003                                           /*S01408*/
/*                                                                    /*S01408*/
 
/**************CALL       PGM(SE0905)                                * *S01117*/
/*/COPY WNCPYSRC,SEC0901007                                          */
               CALL       PGM(SE0905) PARM(&RSEQ &RENT)               /*S01117*/
             ENDDO
/*/COPY WNCPYSRC,SEC0901006                                          */
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
/**/
ERROR:       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/* S01179                                                              *S01179*/
/*********      RCVDTAARA  DTAARA(LDA)                      *********  *S01179*/
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                   /*S01179*/
/***************CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))  * *S01117*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))   /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
                CHGVAR     VAR(&MEM) VALUE('SEC0901 - Job Terminated, +
                          Database in Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
/**/
/* FILE CONTROLS OUT OF BALANCE */
/**/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
              CHGVAR     VAR(&MEM) VALUE('SEC0901 - File Controls out +
                          of Balance')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
/**/
/* NORMAL COMPLETION - CLEAR OUTPUT FILES */
/**/
/*           IF         COND(%SWITCH(XXXXXX00)) THEN(DO)   */
/*           CLRPFM     FILE(IACEXD)                       */
/*           CLRPFM     FILE(IACEXA)                       */
/*           ENDDO                                         */
/**/
/**/
/*ENDPGM:******ENDPGM                                                * *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01117*/
