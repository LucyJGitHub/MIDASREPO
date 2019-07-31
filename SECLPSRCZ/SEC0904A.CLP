/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Cust. Valuation Statmnts on req.')           */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*       SEC0904A - CUSTOMER VALUATION STATEMENT ON REQUEST         */
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
/*       Prev Amend No. S01502             Date 08Jul94              */
/*                      E29170             Date 11Oct91              */
/*                      E29107             DATE 02OCT91              */
/*                      S01117             DATE 29AUG91              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01502 - BLI Telekurs Processing.  Recompiled due to        */
/*                change in length of SESTAT, 133 long.              */
/*       E29170 - REPORT CONTROL FACILITY CHANGES                    */
/*       E29107 - ENTITY LEVEL PARAMETER MISSING                     */
/*       S01117 - MULTIBRANCHING - NEW PROGRAM CREATED FOR RCF       */
/*                                                                   */
/*********************************************************************/
 
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM    PARM(&CSEQ &RENT)                  */             /*E29107*/
             PGM    PARM(&CSEQ &RLEV &RENT)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
 
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
 
/************DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(128)*/           /*S01502*/
             DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(133)             /*S01502*/
 
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
 
             DCL        VAR(&DL) TYPE(*LGL) LEN(1)
 
             DCL        VAR(&RE) TYPE(*LGL) LEN(1)
             DCL        VAR(&IA) TYPE(*LGL) LEN(1)
 
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*E29107*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
/*/COPY WNCPYSRC,SEC0904A01                                          */
 
/* SEND PGM MESSAGE */
 
             CHGVAR     VAR(&MEM) VALUE('SEC0904A - Customer +
                          Valuation Statement')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ)
 
/* CLEAR SWITCHES */
 
             CHGJOB     SWS(00000000)
 
/*DETERMINE MODULES PRESENT BY CHECKING FLAGS IN DTAARA MMOD*/
 
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
 
             CHGVAR     VAR(&DL) VALUE(%SST(&MMOD 2 1) *EQ 'Y')
             CHGVAR     VAR(&RE) VALUE(%SST(&MMOD 16 1) *EQ 'Y')
             CHGVAR     VAR(&IA) VALUE(%SST(&MMOD 23 1) *EQ 'Y')
 
             IF         COND(&DL) THEN(DO)
             CHGJOB     SWS(X1XXXXXX)
             ENDDO
             IF         COND(&RE *OR &IA) THEN(DO)
             CHGJOB     SWS(1XXXXXXX)
             ENDDO
 
/* CHECK IF PORTFOLIO PROCESSING IS LICENSED */
 
/*/COPY WNCPYSRC,SEC0904A03                                          */
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)
             IF         COND(%SST(&SESTAT 64 1) *EQ 'Y') THEN(DO)
/*/COPY WNCPYSRC,SEC0904A04                                          */
 
/*                                                                   * *E29170*/
/*       POSITION FILE TO THE PARTICULAR BRANCH                      * *E29170*/
           IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) THEN(DO) /*E29170*/
             OVRDBF     FILE(CVALS) POSITION(*KEY 1 CVALSDF (&RLEV +
                          *CAT &RENT))                                /*E29170*/
             OPNDBF     FILE(CVALS) OPTION(*ALL)                      /*E29170*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*E29170*/
               DLTOVR     FILE(CVALS)                                 /*E29170*/
             ENDDO                                                    /*E29170*/
             CLOF       OPNID(CVALS)                                  /*E29170*/
             MONMSG     MSGID(CPF0000)                                /*E29170*/
           ENDDO                                                      /*E29170*/
/*/COPY WNCPYSRC,SEC0904A06                                          */
                CALL       PGM(SE0935) PARM(&CSEQ &RENT)
 
/*/COPY WNCPYSRC,SEC0904A05                                          */
             ENDDO
/*/COPY WNCPYSRC,SEC0904A02                                          */
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
 
ERROR:       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
                CHGVAR     VAR(&MEM) VALUE('SEC0904A - Database Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
