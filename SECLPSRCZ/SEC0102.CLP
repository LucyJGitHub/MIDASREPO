/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Create Shadow Postings')                     */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*         SEC0102 - CREATE SHADOW POSTINGS                         */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. CSE114             Date 04Dec23              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01117             Date 10Dec90              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       CSE114 - Exclude Interbranch Events from TREVED and DPEVED  */
/*                when creating SE Shadow Postings.                  */
/*       MD046248 - Finastra Rebranding                              */
/*         S01117 - MULTIBRANCHING                                  */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
/************DCL VAR(&MEM) TYPE(*CHAR) LEN(44)                     */ /*S01117*/
             DCL VAR(&MEM) TYPE(*CHAR) LEN(50)
/**/
/*           DCLDTAARA DTAARA(LDA)                                 */ /*S01179*/
             DCL       VAR(&LDA)    TYPE(*CHAR)  LEN(256)             /*S01179*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CSE114*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                                      /*CSE114*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')                          /*CSE114*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                                    /*CSE114*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CSE114*/
             DCL        VAR(&CSE114) TYPE(*CHAR) LEN(1)                                   /*CSE114*/
/**/
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
/**/
             SNDPGMMSG  MSG('SEC0102 - Create Shadow Postings') +
                          TOMSGQ(MRUNQ)
                                                                                          /*CSE114*/
/** Check if switchable feature CSE114 is switched ON.            */                      /*CSE114*/
/** If ON, override to new LF SETEVL0                             */                      /*CSE114*/
/**/                                                                                      /*CSE114*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CSE114*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CSE114*/
             CHGVAR     VAR(&SAR) VALUE('CSE114')                                         /*CSE114*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CSE114*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CSE114) VALUE('Y'))                                        /*CSE114*/
/**/
             CHGJOB     SWS(00000000)
/**/
             CLRPFM     FILE(GESTMHH)
             CLRPFM     FILE(GESTMPD)
             CLRPFM     FILE(GESTMZZ)
                                                                                          /*CSE114*/
             IF         COND(&CSE114 *EQ 'Y') THEN(DO)                                    /*CSE114*/
             OVRDBF     FILE(SETEV) TOFILE(SETEVL0)                                       /*CSE114*/
             ENDDO                                                                        /*CSE114*/
/**/
/*/COPY WNCPYSRC,SEC0102001                                          */
             CALL       PGM(SE1550)
/**/
/*  ABNORMAL TERMINATION MESSAGE - DATABASE ERROR                   */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*           RCVDTAARA  DTAARA(LDA)                                */ /*S01179*/
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                      /*S01179*/
/************CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44))         */ /*S01117*/
             CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))            /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             SNDPGMMSG  MSG('SEC0102 - Database Error') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
             IF         COND(%SWITCH(XXXXXX01)) THEN(SNDPGMMSG +
                          MSG('SEC0102 - File Controls out of +
                          Balance') TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ))
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
