/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Input Procedure')                            */
/*********************************************************************/
/*                                                                   */
/*       Midas     - System Control Module                       */
/*                                                                   */
/*       MDSINPUT - MIDAS INPUT PROCEDURE                            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01413             Date 13Apr93              */
/*                                         Date                      */
/*                      S01146                  18NOV87              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01413 - Retail 3 Incorporation                             */
/*       S01194 - NEW STANDING DATA                                  */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/***         DCL     VAR(&MEM) TYPE(*CHAR) LEN(44)                 */ /*S01194*/
             DCL     VAR(&MEM) TYPE(*CHAR) LEN(50)                    /*S01194*/
             DCL     VAR(&PGM) TYPE(*CHAR) LEN(8)
             DCL     VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL     VAR(&SWS) TYPE(*CHAR) LEN(8)
/**/
/***         DCLDTAARA DTAARA(LDA)                                  *  *S01179*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*S01179*/
/*/COPY WNCPYSRC,MDSINPUT01                                          */
             OVRDBF     FILE(RETRGD) TOFILE(RETRGD) SHARE(*NO)
             OVRDBF     FILE(RETRG)  TOFILE(RETRG)  SHARE(*NO)
             OVRDBF     FILE(RECRGD) TOFILE(RECRGD) SHARE(*NO)
             OVRDBF     FILE(RECRG)  TOFILE(RECRG)  SHARE(*NO)
             OVRDBF     FILE(REDEFD) TOFILE(REDEFD) SHARE(*NO)
             OVRDBF     FILE(REDEF)  TOFILE(REDEF)  SHARE(*NO)
             OVRDBF     FILE(REINTD) TOFILE(REINTD) SHARE(*NO)
             OVRDBF     FILE(REINT)  TOFILE(REINT)  SHARE(*NO)
             OVRDBF     FILE(STRAN)  TOFILE(STRAN)  SHARE(*NO)
             OVRDBF     FILE(REACR)  TOFILE(REACR)  SHARE(*NO)
             OVRDBF     FILE(ACNUM)  TOFILE(ACNUM)  SHARE(*NO)
/**/
/** TOP:     RCVDTAARA DTAARA(LDA)                                  *  *S01179*/
 TOP:        RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                      /*S01179*/
/**/
             IF COND((%SST(&LDA 1 2)) *NE '**') THEN(DO)
                CHGVAR VAR(&PGM) VALUE(%SST(&LDA 1 8))
/**/
                CALL &PGM
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
                ROLLBACK
                SNDPGMMSG MSG('Transaction failed. Re-input +
                      necessary. Enter to continue.') TOPGMQ(*EXT)
                GOTO ENDPGM
             ENDDO
/**/
                RTVJOBA    JOB(&JOB) SWS(&SWS)
/**/
/*              IF COND(%SWITCH(X0000000)) THEN(GOTO TOP)        *  *S01146*/
                IF COND(%SWITCH(X000X000)) THEN(GOTO TOP)          /*S01146*/
                 IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
/***                RCVDTAARA DTAARA(LDA)                           *  *S01179*/
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                      /*S01179*/
/***                CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 44))      */ /*S01194*/
                    CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))         /*S01194*/
                    ROLLBACK
                    SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)
                    SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOPGMQ(*EXT)
                 ENDDO
/**/
                ENDDO
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 ENDPGM:       ENDPGM
