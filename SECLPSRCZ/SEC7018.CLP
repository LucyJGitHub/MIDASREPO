/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Market Migration - SOBDMVD Component')       */
/*********************************************************************/
/*                                                                   */
/*                                                                   */
/*       Midas     - Securities Trading Module                       */
/*                                                                   */
/*       SEC7018 - Security Market Migration - SOBDMVD Component     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Last Amend No. CSE015 *Create     Date 06Dec99              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CSE015 - Forward Valued Depot Movement                      */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SECURITY &MARKET &DOLIB)
 
 /*  Declare Variables */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&SECURITY) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MARKET) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DOLIB) TYPE(*CHAR) LEN(10)
 
/* Set Off Switches and Monitor Messages */
 
             CHGJOB     SWS(00000000)
             MONMSG     MSGID(CPF0000)
 
/*  Open Query file and call program to update market  */
 
             OVRDBF     FILE(SOBDMVD) SHARE(*YES)
 
             OPNQRYF    FILE((&DOLIB/SOBDMVD)) OPTION(*INP *UPD) +
                          QRYSLT('RECI *NE "*" *AND DPSS *EQ +
                           "' *CAT &SECURITY *CAT '" ') +
                          KEYFLD(*NONE) COMMIT(*YES)
 
             CALL       PGM(SE7018) PARM(&MARKET)
 
             CLOF       OPNID(SOBDMVD)
             DLTOVR     FILE(*ALL)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
