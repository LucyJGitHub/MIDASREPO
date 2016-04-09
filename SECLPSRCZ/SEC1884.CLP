/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Non-Fungible Trades with No Certs')          */
/*********************************************************************/
/*                                                                   */
/*       Midas     - SECURITIES TRADING MODULE                   */
/*                                                                   */
/*       SEC1884 - Non-Fungible Trades with No Certificates List     */
/*                                                                   */
/*       CALLS :   SE1884 - Non-Fungible Trades with No Cert List    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01401             DATE 16JUN93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       S01401 - SWIFT Messages MT5xxs - New Program.               */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
             PGM PARM(&RSEQ &RLEV &RENT)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL (&RSEQ) TYPE(*CHAR) LEN(5)
             DCL (&RLEV) TYPE(*CHAR) LEN(1)
             DCL (&RENT) TYPE(*CHAR) LEN(3)
 
             DCL (&LDA)  TYPE(*CHAR) LEN(256)
             DCL (&MEM)  TYPE(*CHAR) LEN(50)
 
/***  Send program message to inform of process  ***/
 
             CHGVAR (&MEM) VALUE('SEC1884 - Non-Fungible +
                                  Trades with no Certificates')
             SNDPGMMSG MSG(&MEM) TOMSGQ(MRUNQ)
 
/***  Clear job switches and call report program  ***/
 
             CHGJOB SWS(00000000)
             CALL (SE1884) PARM(&RSEQ &RENT)
 
/***  If database error has occurred retrieve  ***/
/***  from LDA and send message.               ***/
 
ERROR:       IF (%SWITCH(XXXXXX11)) THEN(DO)
               RTVDTAARA (LDA) RTNVAR(&LDA)
               CHGVAR (&MEM) VALUE(%SUBSTRING(&LDA 134 50))
               SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                  TOMSGQ(MOPERQ MRUNQ)
               CHGVAR (&MEM) VALUE('SEC1884 - Database Error')
               SNDPGMMSG MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
