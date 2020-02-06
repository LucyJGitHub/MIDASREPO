/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EU Account maintenance')                        */
/*********************************************************************/
/*                                                                   */
/*  Midas   General Ledger Module                            */
/*                                                                   */
/*       EUC0420 - EMU UPDATE OF STATEMENT BLANCE IN EUROS FLAG      */
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
/*       Prev Amend No. CEU013             Date 13Jul98              */
/*                                                                   */
/*********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*   CEU013 - EMU A/C Posting Narrative Enhancements                 */
/*                                                                   */
/*********************************************************************/
/**/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&SRTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SOPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')
             DCL        VAR(&SSARD) TYPE(*CHAR) LEN(6) +
                          VALUE('S01383')
             DCL        VAR(&NBREC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRAL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)                 /*077681*/
             DCLF       FILE(SDMMODPD)
             OVRDBF     FILE(SDMMODPD) TOFILE(SDMMODPD) SHARE(*NO)   /*094525*/
/**/
/** Determine if Retail 3 present   */
/**/
             RCVF
             IF         COND(&BGNXST *EQ 'Y' *OR &BGNYST *EQ 'Y') +
                          THEN(CHGJOB SWS(1XXXXXXX))
             ELSE       CMD(CHGJOB SWS(0XXXXXXX))
/**/
/** Determine if BRT SAR installed  */
/**/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD)
/**/
/** BRT SAR installed */
/**/
             IF         COND(&SRTCD *EQ '       ') THEN(DO)
                CHGJOB SWS(XX1XXXXX)
             ENDDO
/**/
/* Close SCSARDPD File            */
/**/
             CHGVAR     VAR(&SOPTN) VALUE('*FREE')
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD)
/**/
/**/                                                                  /*S01408*/
             CALL       PGM(*LIBL/EU0420)
/**/                                                                  /*S01408*/
/**/                                                                  /*S01408*/
/**/
/* IF U7 AND U8 ARE ON, SEND DATA BASE ERROR MESSAGE TO MOPERQ */     /*077681*/
/* AND *EXT                                                    */     /*077681*/
/**/                                                                  /*077681*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*077681*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MSG)             /*077681*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MSG) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                 /*077681*/
             SNDPGMMSG  MSG('Transaction Failed. Re-input Necessary. +
                          Press Enter to Continue.') TOPGMQ(*EXT)     /*077681*/
             ENDDO                                                    /*077681*/
             CHGJOB     SWS(0XXXXXXX)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
