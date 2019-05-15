/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Shadow balances recreation')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Retail Module                               */
/*                                                                   */
/*       REC67 SHADOW BALANCES FILE CREATION                         */
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
/*       PREV AMEND NO. S01413             DATE 13APR93              */
/*                      E37776                  30MAR92              */
/*                      S01194                  12MAR90              */
/*                      S01154                  31MAY88              */
/*                      S03220                  06MAY88              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01413  -  Header Box Standardised                          */
/*       E37776  -  FTC0260 is now dedundant                         */
/*       S01194  -  New Standing data                                */
/*       S01154  -  Real time statements addition                    */
/*       S03220  -  Funds transfer interface                         */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL VAR(&NMEMOS) TYPE(*DEC) LEN(6)
                                                                      /*S03220*/
             DCL        VAR(&FT) TYPE(*CHAR) LEN(1)                   /*S03220*/
             DCL        VAR(&RESTAT) TYPE(*CHAR) LEN(256)             /*S03220*/
                                                                      /*S03220*/
/**/                                                        /*S01154*/
/************DCL     VAR(&MEM) TYPE(*CHAR) LEN(44)                   * *S01194*/
             DCL     VAR(&MEM) TYPE(*CHAR) LEN(50)                    /*S01194*/
             DCL     VAR(&LDA) TYPE(*CHAR) LEN(256)
/*/COPY WNCPYSRC,REC67001                                            */
/**/                                                        /*S01154*/
             RTVDTAARA DTAARA(RESTAT *ALL) RTNVAR(&RESTAT)
             CHGVAR VAR(&NMEMOS) VALUE(%SST(&RESTAT 1 6))
/**/
             SNDPGMMSG  MSG('REC67 - Shadow Balances File Creation') +
                          TOMSGQ(MRUNQ)
/*/COPY WNCPYSRC,REC67003                                            */
/**/
             CLRPFM FILE(MEMOS)
/**/
             INZPFM FILE(MEMOS) TOTRCDS(&NMEMOS)
/*/COPY WNCPYSRC,REC67004                                            */
             CHGJOB     SWS(XXXXX0XX)
/**/
             OVRDBF FILE(TABLE) TOFILE(TABRE2)
             OVRDBF FILE(MEMO) TOFILE(MEMOS)
             RTVDTAARA  DTAARA(MMOD (57 1)) RTNVAR(&FT)               /*E37776*/
             IF COND(&FT *EQ 'Y') THEN(CHGJOB SWS(XXXX1XXX))          /*E37776*/
/*/COPY WNCPYSRC,REC67005                                            */
             CALL PGM(RE0671)
/*/COPY WNCPYSRC,REC67006                                            */
             CHGJOB SWS(XXXX0XXX)                                     /*E37776*/
             DLTOVR FILE(*ALL)
/**/                                                         /*S01154*/
 ERROR:      IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA DTAARA(LDA *ALL) RTNVAR(&LDA)
/***************CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 44))            * *S01194*/
                CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))             /*S01194*/
                SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/                                                         /*S01154*/
                                                                      /*S03220*/
/*           RTVDTAARA  DTAARA(MMOD (57 1)) RTNVAR(&FT) */ /*S03220*/ /*E37776*/
/*           IF COND(&FT *EQ 'Y') THEN(CALL FTC0260)    */ /*S03220*/ /*E37776*/
                                                                      /*S03220*/
             IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
                SNDPGMMSG  MSG('FILE OUT OF BALANCE - RE0671') +
                          TOMSGQ(MRUNQ MOPERQ)
             ENDDO
/**/
             IF COND(%SWITCH(XXXXX1XX)) THEN(DO)
             SNDPGMMSG MSG('FILE FULL - S/MEMOS') TOMSGQ(MRUNQ MOPERQ)
             ENDDO
/*/COPY WNCPYSRC,REC67002                                            */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
