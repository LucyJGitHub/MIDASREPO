/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UDC - confirmation format layout upd')          */
/*********************************************************************  S37004*/
/*                                                                   */
/*     Midas - Standing Data Module                          */
/*                                                                   */
/*     SDC6812 -  U.D.C. FORMAT UPDATE MAINTENANCE                   */
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
/*     PREV AMEND NO. S01390             DATE 22JUN92                */
/*                    AUS009             DATE 20DEC90                *  AUS009*/
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*     MD046248 - Finastra Rebranding                                */
/*     S01390  -  Release 10 Changes for Australianisation           */
/*     AUS009  -  AUSTRALIAN PRODUCT - USER DEFINED CONFIRMATIONS    *  AUS009*/
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/*                                                                            */
             PGM
/*                                                                            */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USERID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)             /*S01390*/
             DCL        VAR(&REPLY) TYPE(*CHAR) LEN(1)                /*S01390*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*S01390*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*S01390*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*S01390*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*S01390*/
/**/                                                                  /*S01390*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S01390*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*S01390*/
             CHGVAR     VAR(&SAR) VALUE('AUS009')                     /*S01390*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*S01390*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*S01390*/
             RTVMSG     MSGID(XXM0001) MSGF(MIDASMSG) MSG(&MESSAGE)   /*S01390*/
             CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)     /*S01390*/
             RTVMSG     MSGID(XXM0003) MSGF(MIDASMSG) MSG(&MESSAGE)   /*S01390*/
             CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)     /*S01390*/
             RTVMSG     MSGID(XXM0005) MSGF(MIDASMSG) MSG(&MESSAGE)   /*S01390*/
             CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)     /*S01390*/
             CALL       PGM(SCC0040) PARM('SDC6812' 'ENTER' &REPLY)   /*S01390*/
             ENDDO                                                    /*S01390*/
/**/                                                                  /*S01390*/
             ELSE       CMD(DO)                                       /*S01390*/
             CHGJOB     SWS(00000000)
             RTVJOBA    JOB(&WSID)
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&USERID)
/*                                                                            */
             CALL       PGM(SD6812) PARM(&WSID &USERID)
                  MONMSG     MSGID(CPF0000 RPG0000 MCH0000 EDT0000) EXEC( +
                      SNDPGMMSG MSG('Transaction failed. re-input +
                          necessary. Enter to continue.') TOPGMQ(*EXT))
/*                                                                            */
             IF         COND(%SWITCH(XXXXXXX1)) THEN(SNDPGMMSG +
                        MSG('JOB TERMINATED - DATABASE IN ERROR') +
                          TOPGMQ(*EXT) MSGTYPE(*INFO))
/*                                                                            */
             ENDDO                                                    /*S01390*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
