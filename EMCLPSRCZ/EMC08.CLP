/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EM ON REQUEST REPORTING')                       */
/********************************************************************/
/*                                                                  */
/*        Midas     - Exposure Management Module                */
/*                                                                  */
/*       EMC08 - ON REQUEST REPORTING                               */
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
/*       Prev Amend No. S01194             Date 13Dec89              */
/*                      S01117             Date 21Apr90              */
/*                                                                  */
/********************************************************************/
/*       S01117 - MULTIBRANCHING                                    */
/*       MD046248 - Finastra Rebranding                              */
/*       S01194 - STANDING DATA CHANGES                             */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*           PGM        PARM(&PARM)                             */    /*S01117*/
             PGM        PARM(&PARM &RSEQ &RLEV &RENT &RPARM)          /*S01117*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/*           DCL        VAR(&MEM) TYPE(*CHAR) LEN(44) */              /*S01194*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01194*/
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(8)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*S01117*/
/**/
             CHGJOB SWS(00000000)
/**/
             OVRDBF     FILE(TABLE) TOFILE(TABEM)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
/**/
/*           CALL       PGM(&PARM)                           */       /*S01117*/
             CALL       PGM(&PARM) PARM(&RSEQ &RLEV &RENT &RPARM)     /*S01117*/
/**/
             DLTOVR     FILE(TABLE)
/**/
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                        */
/**/
              IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                  RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
/*             CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 44)) */           /*S01194*/
                  CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))           /*S01194*/
                  SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOPGMQ(*EXT) TOMSGQ(MOPERQ)
              ENDDO
/**/
/* FOR FILE CONTROLS OUT OF BALANCE                                  */
/**/
              IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                  SNDPGMMSG MSGID(MEM0002) MSGF(MIDAS)  +
                            TOPGMQ(*EXT) TOMSGQ(MOPERQ)
/**/
              ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
           ENDPGM
