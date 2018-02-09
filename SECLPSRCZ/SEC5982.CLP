/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Security W/out Telekur Price Report')        */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Securities Trading Module                       */
/*                                                                   */
/*       SEC5982 - Securities W/out Telekurs Price Report (Servitia) */
/*                                                                   */
/*       Function: Produces the Securities W/out Telekurs Price      */
/*                 report on input cycle upon request.               */
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
/*       Prev Amend No. CSE009             Date 16Mar99              */
/*                      S01502  *CREATE    Date 08Jul94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSE009 - Telekurs Changes                                   */
/*       S01502 - BLI Telekurs Processing.                           */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(133)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&TELK)   TYPE(*CHAR) LEN(7) VALUE('       ')                  /*CSE009*/
             DCL        VAR(&OPTN)   TYPE(*CHAR) LEN(7) VALUE('*FIRST ')                  /*CSE009*/
             DCL        VAR(&SAR)    TYPE(*CHAR) LEN(6)                                   /*CSE009*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CSE009*/
             DCL        VAR(&DAYS) TYPE(*DEC) LEN(5 0)                                    /*CSE009*/
                                                                                          /*CSE009*/
             DCLF       FILE(SDBANKPD)                                                    /*CSE009*/
 
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)
 
             IF         COND(%SST(&SESTAT 129 1) *EQ 'N') THEN(GOTO +
                          CMDLBL(END))
 
             CHGDTAARA  DTAARA(LDA)   VALUE(' ')
             CHGJOB SWS(00000000)
 
             OVRDBF     FILE(SDBANKPD) SHARE(*NO)                                         /*CSE009*/
             RCVF                                                                         /*CSE009*/
             CHGVAR     VAR(&DAYS) VALUE(&BJRDNB)                                         /*CSE009*/
                                                                                          /*CSE009*/
             CHGVAR     VAR(&TELK) VALUE('       ')                                       /*CSE009*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CSE009*/
             CHGVAR     VAR(&SAR)  VALUE('CSE009')                                        /*CSE009*/
                                                                                          /*CSE009*/
             CALL       PGM(AOSARDR0) PARM(&TELK &OPTN &SAR &SCSARD)                      /*CSE009*/
                                                                                          /*CSE009*/
             IF         COND((&TELK *EQ '       ') *OR (&DAYS >= +
                          09978)) THEN(CHGJOB SWS(01000000))                              /*CSE009*/
             ELSE       CMD(CHGJOB SWS(10000000))                                         /*CSE009*/
                                                                                          /*CSE009*/
             CALL       PGM(SE5982)  PARM(&RSEQ)
 
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                         */
/**/
             IF  COND(%SWITCH(XXXXXX11)) THEN(DO)
                  RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                  CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))
                  SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                  TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
