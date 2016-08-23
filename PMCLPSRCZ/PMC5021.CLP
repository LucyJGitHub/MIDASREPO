/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Pool Customer Portfolio Enquiry')            */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC5021 - PM POOL CUSTOMER PORTFOLIO ENQUIRY                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01486             DATE 26AUG94              */
/*       PREV AMEND NO. 049421             DATE 18JAN93              */
/*                      S01313             DATE 20SEP92              */
/*                      SA9108             DATE 07APR92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       S01486 - Private Banking Upgrade to Release 10              */
/*       049421 - HEADER BOX STANDARDISATION                         */
/*       S01313 - PORTFOLIO PERFORMANCE CHANGES                      */
/*       SA9108 - WRITTEN FOR POOL SECURITIES                        */
/*                                                                   */
/*********************************************************************/
/**/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/************DCL        VAR(&WWMULT) TYPE(*CHAR) LEN(2)                *S01486*/
/************DCL        VAR(&WWMSGF) TYPE(*CHAR) LEN(10)               *S01486*/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
 
/************SETATNPGM  PGM(SDC2330)                                   *S01486*/
 
/************STRCMTCTL  LCKLVL(*CHG)                                   *S01486*/
/************MONMSG     CPF8351                                        *S01486*/
 
 
/****RETRIEVE*USER*LANGUAGE*FROM*DTAARA**LDA****************************S01486*/
/************                                                          *S01486*/
/*>>> S01313 >>>*/
/*********** RTVDTAARA  DTAARA(*LDA (535 2)) RTNVAR(&WWMULT)             ******/
/************RTVDTAARA  DTAARA(*LDA (530 2)) RTNVAR(&WWMULT)           *S01486*/
/*<<< S01313 <<<*/
/************IF         COND(&WWMULT *EQ '  ') THEN(DO)                *S01486*/
/************  CHGVAR     VAR(&WWMULT) VALUE('GB')                     *S01486*/
/************ENDDO                                                     *S01486*/
/************                                                          *S01486*/
/****OVERRIDE*MESSAGES*FILES*USING*USER*LANGUAGE************************S01486*/
/************                                                          *S01486*/
/************CHGVAR     VAR(&WWMSGF) VALUE(&WWMULT *CAT 'PMUSRMSG')    *S01486*/
/************OVRMSGF    MSGF(PMUSRMSG) TOMSGF(&WWMSGF)                 *S01486*/
/************                                                          *S01486*/
/************CHGVAR     VAR(&WWMSGF) VALUE('"          "')             *S01486*/
/************CHGVAR     VAR(&WWMSGF) VALUE(&WWMULT *CAT 'LBUSRMSG')    *S01486*/
/************OVRMSGF    MSGF(LBUSRMSG) TOMSGF(&WWMSGF)                 *S01486*/
/************                                                          *S01486*/
/************CHGVAR     VAR(&WWMSGF) VALUE('"          "')             *S01486*/
/************CHGVAR     VAR(&WWMSGF) VALUE('ML' *CAT &WWMULT  *CAT +   *S01486*/
/************             'MSGF')                                      *S01486*/
/************OVRMSGF    MSGF(MLGBMSGF) TOMSGF(&WWMSGF)                 *S01486*/
/************CHGVAR     VAR(&WWMSGF) VALUE('ZZ' *CAT &WWMULT  *CAT +   *S01486*/
/************             'MSGF')                                      *S01486*/
/************OVRMSGF    MSGF(ZZGBMSGF) TOMSGF(&WWMSGF)                 *S01486*/
 
/** RECEIVE NAME OF USER CURRENTLY SIGNED ON  */
 
             RTVJOBA    USER(&USER)
 
/**  CALL PROGRAM RPG/PM5020 */
 
             CALL       PGM(PM5020) PARM(&USER)
 
/***********ENDPGM:        ENDPGM                                      *S01486*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01486*/
