/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Market Migration - CNCTRD')                  */
/*********************************************************************/
/*                                                                   */
/*                                                                   */
/*       Midas     - Securities Trading Module                       */
/*                                                                   */
/*       SEC7015 - SECURITY MARKET MIGRATION - CNCTRD COMPONENT      */
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
/*       PREV AMEND NO. S01511 *CREATE     DATE 10AUG94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01511 - Market Migration                                   */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/********************************************************************/
             PGM        PARM(&SECURITY &MARKET &DOLIB)
 
 /*  DECLARE VARIABLES */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&SECURITY) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MARKET) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DOLIB) TYPE(*CHAR) LEN(10)
 
/* SET OFF SWITCHES AND MONITOR MESSAGES */
 
             CHGJOB     SWS(00000000)
             MONMSG     MSGID(CPF0000)
 
/*  OPEN QUERY FILE AND CALL PROGRAM TO UPDATE MARKET  */
/*-----------------------------------------------------*/
 
             OVRDBF     FILE(CNCTRD) SHARE(*YES)
 
             OPNQRYF    FILE((&DOLIB/CNCTRD)) OPTION(*INP *UPD) +
                          QRYSLT('RECI *NE "*" *AND TDSS *EQ +
                           "' *CAT &SECURITY *CAT '" ') +
                          KEYFLD(*NONE) COMMIT(*YES)
 
             CALL       PGM(SE7015) PARM(&MARKET)
 
             CLOF       OPNID(CNCTRD)
             DLTOVR     FILE(*ALL)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
