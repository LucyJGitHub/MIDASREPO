/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UDC - confirmation format name upd.')           */
/*********************************************************************  S37004*/
/*                                                                   */
/*     Midas - Standing Data Module                          */
/*                                                                   */
/*     SDC6811 -  U.D.C. FORMAT NAMES MANTENANCE                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*     LAST AMEND NO.  S01390            DATE 22JUN92                */
/*     PREV AMEND NO.  AUS009            DATE 20DEC90                *  AUS009*/
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
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
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
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
             CALL       PGM(SCC0040) PARM('SDC6811' 'ENTER' &REPLY)   /*S01390*/
             ENDDO                                                    /*S01390*/
/**/                                                                  /*S01390*/
             ELSE       CMD(DO)                                       /*S01390*/
             RTVJOBA    JOB(&WSID)
/*                                                                            */
             CALL       PGM(SD6811) PARM(&WSID)
                  MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(SNDPGMMSG +
                             MSG('Transaction failed. re-input +
                                  necessary. Enter to continue.') TOPGMQ(*EXT))
/*                                                                            */
             ENDDO                                                    /*S01390*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
