/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Input Procedure')                            */
/*********************************************************************/
/*                                                                   */
/*       Midas      -  RETAIL II MODULE                          */
/*                                                                   */
/*             GLINPUT  -  GENERAL LEDGER INPUT PROCEDURE            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CGL029             Date 01Sep03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01383             Date 27Apr92              */
/*                      S01311             Date 12Apr91              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CGL029 - Increase Account Code to 10 digits                 */
/*         S01383 - BASIC RATE TAX INCORPORATION                     */
/*         S01311 - EXPOSURE MANAGEMENT ENQUIRIES                    */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL     VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL     VAR(&MODULE) TYPE(*CHAR) LEN(1)
             DCL     VAR(&PGM) TYPE(*CHAR) LEN(8)
             DCL     VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL     VAR(&SWS) TYPE(*CHAR) LEN(8)
/**********  DCL     VAR(&EMSDS) TYPE(*CHAR) LEN(161)                */        /*S01311*/ /*CGL029*/
             DCL     VAR(&EMSDS) TYPE(*CHAR) LEN(167)                                     /*CGL029*/
             DCL     VAR(&PGN1D) TYPE(*CHAR) LEN(8)                  /*S01311*/
/**/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/*/COPY WNCPYSRC,GLINPUT001                                          */
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
             OVRDBF     FILE(ACCNT)  TOFILE(ACCNT)  SHARE(*NO)
             OVRDBF     FILE(REIACD) TOFILE(REIACD) SHARE(*NO)
             OVRDBF     FILE(REIAC)  TOFILE(REIAC)  SHARE(*NO)
/*/COPY WNCPYSRC,GLINPUT002                                          */
/**/
 TOP:        RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
/**/
             IF COND((%SST(&LDA 1 2)) *NE '**') THEN(DO)
                CHGVAR VAR(&PGM) VALUE(%SST(&LDA 1 6))
                CHGVAR VAR(&MODULE) VALUE(%SST(&LDA 8 1))
/**/                                                                 /*S01311*/
/*   IF POSITIONS 2 TO 9 ON DTAARA/EMSDS ARE BLANK, THIS IS THE   */ /*S01311*/
/*   FIRST ENQUIRY IN THE STACK, SO CLEAR DTAARA/EMSDS            */ /*S01311*/
/**/                                                                 /*S01311*/
             RTVDTAARA DTAARA(EMSDS) RTNVAR(&EMSDS)                  /*S01311*/
             CHGVAR     VAR(&PGN1D) VALUE(%SST(&EMSDS 2 8))          /*S01311*/
             IF COND(&PGN1D *EQ '        ') THEN(DO)                 /*S01311*/
                CHGDTAARA  DTAARA(EMSDS) VALUE(' ')                  /*S01311*/
             ENDDO                                                   /*S01311*/
                                                                     /*S01311*/
/**/
                CALL       PGM(&PGM) PARM(&MODULE)
                MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
                   ROLLBACK
                   SNDPGMMSG MSG('Transaction failed. Re-input +
                         necessary. Enter to continue.') TOPGMQ(*EXT)
                   GOTO ENDPGM
                ENDDO
/**/
/*   FOR LINKED ENQUIRIES, IF THIS IS FIRST ENQUIRY IN STACK,     */ /*S01311*/
/*   DETERMINE IF DATABASE ERROR HAS OCCURRED                     */ /*S01311*/
                                                                     /*S01311*/
             RTVDTAARA DTAARA(EMSDS) RTNVAR(&EMSDS)                  /*S01311*/
             CHGVAR     VAR(&PGN1D) VALUE(%SST(&EMSDS 2 8))          /*S01311*/
             IF COND(&PGN1D *EQ '        ') THEN(DO)                 /*S01311*/
                RTVJOBA    JOB(&JOB) SWS(&SWS)
/**/
/***************IF COND(%SWITCH(0X00X000)) THEN(GOTO TOP)         */ /*S01311*/
/***************IF COND(%SWITCH(0X00X010)) THEN(DO)               */ /*S01311*/
/***************IF COND(%SWITCH(XX00X000)) THEN(GOTO TOP) /*S01311*/ /*S01383*/
/***************IF COND(%SWITCH(XX00X010)) THEN(DO)       /*S01311*/ /*S01383*/
                IF COND(%SWITCH(XXX0X000)) THEN(GOTO TOP)            /*S01383*/
                IF COND(%SWITCH(XXX0X010)) THEN(DO)                  /*S01383*/
                   RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                   CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))
                   ROLLBACK
                   SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ)
                   SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT)
                ENDDO
             ENDDO                                                   /*S01311*/
/**/
             ENDDO
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
