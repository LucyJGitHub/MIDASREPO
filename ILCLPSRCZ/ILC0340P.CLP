/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IBLC 2002 Routing keys list - Prompt')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - IBLC 2002 Module                                    */
/*                                                                   */
/*       ILC0340P - Routing Keys List - prompt                       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CER001             Date 25Apr05              */
/*       Prev Amend No. ULX043             Date 28Jun01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX043 - IBLC 2002 Reporting                                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM &ACTION &CMD)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
 
/***  Declare Data for display at selection screen.  ***/
 
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATUM) TYPE(*CHAR) LEN(7)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CMD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OPTION) TYPE(*CHAR) LEN(2)
 
/***  Display file.  ***/
 
             DCLF       FILE(ILC0340DF) RCDFMT(ILC0340X0)
 
/***  Retrieve job information (standard display).  ***/
 
             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&JOB) VALUE('ILC0340P')
             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&DATUM)
 
/***  Read choice.  ***/
 
 SCREEN:     SNDRCVF    RCDFMT(ILC0340X0)
 
/***  Reset external switches.  ***/
 
             IF         COND(&OPTION *NE *BLANKS) THEN(CHGVAR +
                          VAR(&RPARM) VALUE(&OPTION))
 
 RUN:        CHGJOB     SWS(0XXXXX00)
 
/***  Cmd03 goto end.  ***/
 
             IF         COND(&IN03) THEN(GOTO CMDLBL(ENDPGM))
 
/***  Setup parameters depending of Option entered.  ***/
 
 ENDPGM:     CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International +
                          Banking Systems Ltd. 2005')
             MONMSG     MSGID(CPF0000)
             ENDPGM
