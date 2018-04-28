/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Market Migration - UDEPPD')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Securities Trading Module                       */
/*                                                                   */
/*       SEC7011 - SECURITY MARKET MIGRATION - UDEPPD COMPONENT      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01511 *CREATE     DATE 10AUG94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       S01511 - Market Migration                                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SECURITY &MARKET &DOLIB)
 
 /*  DECLARE VARIABLES */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&SECURITY) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MARKET) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DOLIB) TYPE(*CHAR) LEN(10)
 
/* SET OFF SWITCHES AND MONITOR MESSAGES                            */
 
             CHGJOB     SWS(00000000)
             MONMSG     MSGID(CPF0000)
 
/*  OPEN QUERY FILE AND CALL PROGRAM TO UPDATE MARKET  */
/*-----------------------------------------------------*/
 
             OVRDBF     FILE(UDEPPD) SHARE(*YES)
 
             OPNQRYF    FILE((&DOLIB/UDEPPD)) OPTION(*INP *UPD) +
                          QRYSLT('RECI *NE "*" *AND UDSN *EQ +
                           "' *CAT &SECURITY *CAT '" ') +
                          KEYFLD(*NONE) COMMIT(*YES)
 
             CALL       PGM(SE7011) PARM(&MARKET)
             CLOF       OPNID(UDEPPD)
 
             OVRDBF     FILE(BKPHHD) SHARE(*YES)
             DLTOVR     FILE(*ALL)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
