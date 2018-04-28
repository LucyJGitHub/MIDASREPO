/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MQ RTEVENTS Get Mbr Change Date')               */
/*********************************************************************/
/*                                                                   */
/*      Midas - Midas/Q Module                                       */
/*                                                                   */
/*      MQ543XC - Retrieves the Member Change Date for MQ541XPF      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 193655             Date 26MAY06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CMQ001             Date 31OCT97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       193655 - Mismatch on pgm variable since Year 2000           */
/*       CMQ001 - MidasQ rationalisation.                            */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&MQID &CHG &GEN)
/**/
             DCL        VAR(&MQID) TYPE(*CHAR) LEN(8)
/*********** DCL        VAR(&CHG) TYPE(*DEC) LEN(12)                                      /*193655*/
             DCL        VAR(&CHG) TYPE(*DEC) LEN(13)                                      /*193655*/
             DCL        VAR(&CHG13) TYPE(*CHAR) LEN(13)
             DCL        VAR(&TEXT) TYPE(*CHAR) LEN(50)
             DCL        VAR(&GEN) TYPE(*CHAR) LEN(3)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             RTVMBRD    FILE(MQ541XPF) MBR(&MQID) TEXT(&TEXT) +
                          CHGDATE(&CHG13)
             CHGVAR     VAR(&CHG) VALUE(&CHG13)
             CHGVAR     VAR(&GEN) VALUE(&TEXT)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
