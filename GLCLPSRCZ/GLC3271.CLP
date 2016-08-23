/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Account Maintenance')                        */
/*********************************************************************/
/*                                                                   */
/*  Midas   General Ledger Module                            */
/*                                                                   */
/*       GLC3271 - OPENING ACCOUNT AND MAINTENANCE                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 077681              DATE 14JAN98             */
/*       PREV AMEND NO. S01408              DATE 10JAN96             */
/*                      094525              DATE 12OCT95             */
/*                      041702              DATE 27SEP93             */
/*                      S01413 *CREATE      DATE 13APR93             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       077681  -  No transaction failure message returned to the   */
/*                  screen when an error occurs - amend program to   */
/*                  send an error message.                           */
/*       S01408  -  Addition of core hooks GLC3271INT                */
/*                                         GLC3271MP1                */
/*                                         GLC3271MP2                */
/*       094525  -  CPF0864 in GLC3271 because component shares      */
/*                  ODP with file defined as SHARE(*YES).            */
/*       041702  -  Verify the size of STRAN file to be able to      */
/*                  display a file full msg instead a DB error msg.  */
/*       S01413  -  Retail 3 Incorporation                           */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&ENQY)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&SRTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SOPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')
             DCL        VAR(&SSARD) TYPE(*CHAR) LEN(6) +
                          VALUE('S01383')
             DCL        VAR(&ENQY) TYPE(*CHAR) LEN(1)
/*>> 041702 >>*/
             DCL        VAR(&NBREC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRAL) TYPE(*CHAR) LEN(10)
/*<< 041702 <<*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,GLC3271INT                                          */
/**/                                                                  /*S01408*/
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
/*/COPY WNCPYSRC,GLC3271002                                          */
/**/
/* Close SCSARDPD File            */
/**/
             CHGVAR     VAR(&SOPTN) VALUE('*FREE')
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD)
/*/COPY WNCPYSRC,GLC3271001                                          */
/**/
/*>> 041702 >>*/
             RTVMBRD    FILE(STRAN) NBRCURRCD(&NBREC)
             CHGVAR     VAR(&NBRAL) VALUE(&NBREC)
/*<< 041702 <<*/
             OVRDBF     FILE(ACCNTLXX) TOFILE(ACCBR) SHARE(*NO)
             OVRDBF     FILE(REIACXX) TOFILE(REIAC) SHARE(*NO)
             OVRDBF     FILE(RECOMXX) TOFILE(RECOM) SHARE(*NO)
/**/
/*>> 041702 >>*/
/*********** CALL       PGM(*LIBL/GL3271) *****************************/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,GLC3271MP1                                          */
/**/                                                                  /*S01408*/
             CALL       PGM(*LIBL/GL3271) PARM(&NBRAL &ENQY)
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,GLC3271MP2                                          */
/**/                                                                  /*S01408*/
/*<< 041702 <<*/
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
             DLTOVR     FILE(*ALL)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
