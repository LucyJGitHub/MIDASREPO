/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Unrealized Profit & Loss Analysis')          */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*       SEC0902 - UNREALISED PROFIT AND LOSS ANALYSIS              */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 224132             Date 22Dec03              */
/*                      CAS006             Date 21Jan03              */
/* Midas Release 4.01 -----------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01117             Date  10Jan91            */
/*                      E23248             Date  10Sep90            */
/*                      S01179             DATE  16/09/88           */
/*                      E13575             DATE  29/07/88           */
/*                      S01158             DATE  19/05/88           */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       224132 - Run Rprts with Price Format for Yield Based        */
/*                Securities first.                                  */
/*       CAS006 - Hedge Accounting Phase B                           */
/*         S01117 - MULTIBRANCHING                                  */
/*         E23248 - ALLOW USER TO REQUEST YIELDS ON SE0915          *  *E23248*/
/*         S01179 -     RELEASE                                     *  *S01179*/
/*         E13575 - ENABLE TRADE DATE, VALUE DATE OR BOTH.          *  *E13575*/
/*         S01158 - POST INCORPORATION ERROR FIX.                   *  *S01158*/
/*                                                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*           PGM                                                 */   /*S01158*/
/*                                                               */   /*S01158*/
/************PGM        PARM(&DTBS)                                     E23248*/
/************PGM        PARM(&DTBS &PRTYPE)                   *E23248* *S01117*/
/*/COPY WNCPYSRC,SEC0902002                                          */
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)                /*S01117*/
/*/COPY WNCPYSRC,SEC0902003                                          */
/*                                                               */   /*S01158*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
/* S01179                                                              *S01179*/
/*********   DCLDTAARA  DTAARA(LDA)                          ********  *S01179*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*S01179*/
/**/
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)               * *S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&DTBS) TYPE(*CHAR) LEN(1)
             /* T=TRADE DATE BASIS , V=VALUE DATE BASIS */
             DCL        VAR(&PRTYPE) TYPE(*CHAR) LEN(1)               /*E23248*/
             /* Y=YIELDS, P=PERCENTAGE PRICES */                      /*E23248*/
/*/COPY WNCPYSRC,SEC0902004                                          */
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*S01117*/
             DCL        VAR(&OPTION) TYPE(*CHAR) LEN(1)               /*S01117*/
 
/* Declare the variables to check the enhancements file */                                /*224132*/
                                                                                          /*224132*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*224132*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                                                /*224132*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) +
                          VALUE('CAS006')                                                 /*224132*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                                    /*224132*/
             DCL        VAR(&CAS006) TYPE(*CHAR) LEN(1) +
                          VALUE(' ')                                                      /*224132*/
                                                                                          /*224132*/
/* Check if enhancement CAS006 in installed */                                            /*224132*/
                                                                                          /*224132*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)                        /*224132*/
                                                                                          /*224132*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAS006) VALUE('Y'))                                        /*224132*/
             IF         COND(&CAS006 *EQ ' ') THEN(DO)                                    /*224132*/
                CHGVAR     VAR(&PRTYPE) VALUE(%SST(&RPARM 2 1))                           /*224132*/
                GOTO       CMDLBL(REPEAT)                                                 /*224132*/
             ENDDO                                                                        /*224132*/
                                                                                          /*224132*/
             CHGVAR     VAR(&PRTYPE) VALUE('P')                                           /*224132*/
                                                                                          /*224132*/
REPEAT:                                                                                   /*224132*/
             CLRPFM     FILE(SEMKVAPD)                                                    /*CAS006*/
/* EXTRACT PROMPT PARAMETERS FROM RCF */                              /*S01117*/
             CHGVAR     VAR(&OPTION) VALUE(%SST(&RPARM 1 1))          /*S01117*/
/**********  CHGVAR     VAR(&PRTYPE) VALUE(%SST(&RPARM 2 1)) */                    /*S01117 224132*/
 
/* IF WANT BOTH REPORTS DO BY TRADE DATE FIRST                       * *S01117*/
             IF         COND(&OPTION *EQ 'B') THEN(CHGVAR VAR(&DTBS) +
                          VALUE('T'))                                 /*S01117*/
             ELSE       CMD(CHGVAR VAR(&DTBS) VALUE(&OPTION))         /*S01117*/
 
/**/
/* SEND PGM MESSAGE */
/**/
             CHGVAR     VAR(&MEM) VALUE('SEC0902 - Unrealised Profit +
                          & Loss Analysis')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ)
 
/*/COPY WNCPYSRC,SEC0902005                                          */
/*******TEMPORARY*PATCH*TO*MAKE*PGM*WORK****/                         /*S01158*/
/*           CHGVAR     VAR(&DTBS) VALUE('T')                     */  /*S01158*/
AGAIN:
 
/**/
/* CLEAR SWITCHES */
/**/
             CHGJOB     SWS(00000000)
/**/
/* CLEAR OUTPUT FILES */
/**/
             CLRPFM     FILE(UPLEXD)
             CLRPFM     FILE(UPLEXA)
/**/
/* PERFORM OVERRIDES DEPENDING ON INPUT PARAMETER */
/**/
             IF         COND(&DTBS *EQ 'T') THEN( +
                OVRDBF     FILE(BKPHJ3) TOFILE(BKPHJ3T))
/*           ELSE (OVRDBF     FILE(BKPHJ3) TOFILE(BKPHJ3V))        */ /*E13575*/
             ELSE (OVRDBF     FILE(BKPHJ3T) TOFILE(BKPHJ3V))          /*E13575*/
/**/
/* CALL SE0910 (EXTRACT) */
/**/
             CALL       PGM(SE0910) PARM(&DTBS)
/**/
/* IF NO ERRORS CALL SE0915 (REPORT) */
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/*       POSITION FILE TO THE PARTICULAR BRANCH                      * *S01117*/
           IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) THEN(DO) /*S01117*/
             OVRDBF     FILE(UPLEX) POSITION(*KEY 1 UPLEXDF &RENT)    /*S01117*/
             OPNDBF     FILE(UPLEX) OPTION(*ALL)                      /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
               DLTOVR     FILE(UPLEX)                                 /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(UPLEX)                                  /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
           ENDDO                                                      /*S01117*/
 
/**************CALL       PGM(SE0915) PARM(&DTBS)                       E23248*/
/**************CALL       PGM(SE0915) PARM(&DTBS &PRTYPE)     *E23248* *S01117*/
/*/COPY WNCPYSRC,SEC0902001                                          */
               CALL       PGM(SE0915) PARM(&DTBS &PRTYPE &RSEQ &RENT) /*S01117*/
             ENDDO
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
                CHGVAR     VAR(&MEM) VALUE('SEC0902 - Job Terminated, +
                          Database in Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
/**/
/* FILE CONTROLS OUT OF BALANCE */
/**/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
              CHGVAR     VAR(&MEM) VALUE('SEC0902 - File Controls out +
                          of Balance')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/**************MORE*TEMPORARY*BITS***********/                        /*E13575*/
 
/*           IF         COND(&DTBS *EQ 'T') THEN(DO)       */         /*E13575*/
/*           CHGVAR     VAR(&DTBS) VALUE('V')              */         /*E13575*/
/*           GOTO       CMDLBL(AGAIN)                      */         /*E13575*/
/*           ENDDO                                         */         /*E13575*/
 
/**/
/* NORMAL COMPLETION - CLEAR OUTPUT FILES */
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                CLRPFM     FILE(UPLEXD)
                CLRPFM     FILE(UPLEXA)
             ENDDO
/**/
/* DELETE ALL FILE OVERIDES */                                        /*S01158*/
                                                                      /*S01158*/
             DLTOVR *ALL                                              /*S01158*/
                                                                      /*S01158*/
/* IF WANT BOTH REPORTS DO BY VALUE DATE SECOND                      * *S01117*/
             IF         COND(&OPTION *EQ 'B' *AND &DTBS *EQ 'T') +
                          THEN(DO)                                    /*S01117*/
             CHGVAR     VAR(&DTBS) VALUE('V')                         /*S01117*/
             GOTO       CMDLBL(AGAIN)                                 /*S01117*/
             ENDDO                                                    /*S01117*/
 
             IF         COND(&CAS006 *EQ ' ') THEN(GOTO CMDLBL(ENDPGM))                   /*224132*/
                                                                                          /*224132*/
             IF         COND(&PRTYPE *EQ 'P') THEN(DO)                                    /*224132*/
             CHGVAR     VAR(&PRTYPE) VALUE('Y')                                           /*224132*/
             GOTO       CMDLBL(REPEAT)                                                    /*224132*/
             ENDDO                                                                        /*224132*/
                                                                                          /*224132*/
/**/
/*ENDPGM:******ENDPGM                                                * *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01117*/
